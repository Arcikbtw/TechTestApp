//
// Created by Artur Dąbkowski on 09/12/2021.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

protocol ShowAlertProtocol: AnyObject {
    func showAlert(title: String, message: String)
}

protocol AlbumListViewControllerDelegate: ShowAlertProtocol {}

final class AlbumListViewController: UIViewController {
    private let viewModel: AlbumListViewModel
    private let disposeBag: DisposeBag = DisposeBag()
    private let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    private let tableView: UITableView = UITableView()
    private weak var delegate: AlbumListViewControllerDelegate?

    // MARK: - Constructor

    init(viewModel: AlbumListViewModel, delegate: AlbumListViewControllerDelegate) {
        self.delegate = delegate
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareSubviews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let buttonItem = UIBarButtonItem(title: NSLocalizedString("global.refresh", comment: ""), style: .done, target: nil, action: nil)
        buttonItem.rx.tap.bind(to: viewModel.input.reload).disposed(by: disposeBag)
        navigationItem.rightBarButtonItem = buttonItem

        setupBindings()
        viewModel.input.reload.accept(())
    }

    // MARK: - Bindings

    private func setupBindings() {
        viewModel.output.title.asObservable().bind(to: rx.title).disposed(by: disposeBag)

        let isLoading = viewModel.output.loading.asObservable()
        isLoading.bind(to: loadingIndicator.rx.isAnimating).disposed(by: disposeBag)
        isLoading.toggle().bind(to: tableView.rx.isUserInteractionEnabled).disposed(by: disposeBag)
        isLoading.toggle().bind(to: loadingIndicator.rx.isHidden).disposed(by: disposeBag)

        let refresh: Observable<[AlbumTableViewCellModel]> = viewModel.output.refresh.asObservable().share()
        refresh.bind(to: tableView.rx.items(cellIdentifier: AlbumTableViewCell.cellIdent)) { _, model, cell in
                    guard let albumCell: AlbumTableViewCell = cell as? AlbumTableViewCell else { return }
                    albumCell.updateContent(model: model)
        }
        .disposed(by: disposeBag)

        viewModel.output.error.asObservable()
                .withUnretained(self).subscribe(onNext: { owner, error in
                    owner.delegate?.showAlert(title: error.title, message: error.message)
        })
                .disposed(by: disposeBag)
    }

    // MARK: - Build view

    private func prepareSubviews() {
        view.addSubviewAndFill(tableView)
        tableView.delegate = nil
        tableView.dataSource = nil
        tableView.register(AlbumTableViewCell.self, forCellReuseIdentifier: AlbumTableViewCell.cellIdent)
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension

        view.addSubviewAndCenter(loadingIndicator)
    }
}
