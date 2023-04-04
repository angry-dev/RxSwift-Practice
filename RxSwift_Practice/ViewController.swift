//
//  ViewController.swift
//  RxSwift_Practice
//
//  Created by Hyesung Jeon on 2023/04/04.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController, UISearchBarDelegate {
    
    var shownCities = [String]()
    let allCities = ["New York", "London", "Oslo", "Warsaw", "Berlin", "Praga"] // 고정된 API 데이터
    
    let disposeBag = DisposeBag()

    @IBOutlet weak var searchView: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchView.delegate = self
        
        searchView
            .rx.text // RxCocoa의 Observable 속성
            .orEmpty // 옵셔널이 아니도록 만듭니다.
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance) // Wait 0.5 for changes.
            .distinctUntilChanged() // 새로운 값이 이전의 값과 같은지 확인합니다.
            .subscribe(onNext: { [unowned self] text in // 이 부분 덕분에 모든 새로운 값에 대한 알림을 받을 수 있습니다.
                print(text)
                self.shownCities = self.allCities.filter { $0.lowercased().hasPrefix(text) } // 도시를 찾기 위한 “API 요청” 작업을 합니다.
                self.tableView.reloadData() // 테이블 뷰를 다시 불러옵니다.
            })
            .disposed(by: self.disposeBag)
    }


}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shownCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityPrototypeCell", for: indexPath)
            cell.textLabel?.text = shownCities[indexPath.row]

            return cell
    }
    
    
}

