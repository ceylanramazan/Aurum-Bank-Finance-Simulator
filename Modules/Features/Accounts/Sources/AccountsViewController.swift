import UIKit
import BankingDomain

/// Programmatic UIKit screen — a single table listing every account's IBAN and balance.
final class AccountsViewController: UIViewController {

    // MARK: - Properties

    private let viewModel: AccountsViewModel
    private let tableView = UITableView()
    private let cellReuseIdentifier = "AccountCell"

    private let balanceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    // MARK: - Init

    init(viewModel: AccountsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported — this screen is built programmatically.")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Accounts"
        view.backgroundColor = .systemBackground
        setUpTableView()
        bindViewModel()
        viewModel.load()
    }

    // MARK: - Setup

    private func setUpTableView() {
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource

extension AccountsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.accounts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
            ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellReuseIdentifier)
        let account = viewModel.accounts[indexPath.row]
        cell.textLabel?.text = account.iban
        cell.detailTextLabel?.text = balanceFormatter.string(from: account.balance as NSDecimalNumber)
        return cell
    }
}
