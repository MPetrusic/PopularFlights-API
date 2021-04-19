//
//  ViewController.swift
//  KiwiFlights
//
//  Created by Milos Petrusic on 19.4.21..
//

import UIKit

class ViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let spinnerView: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.backgroundColor = .lightGray
        return spinner
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Kiwi's Best Deals!"
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textColor = UIColor(hex: "#01A991ff")
        label.textAlignment = .center
        return label
    }()
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 5
        pageControl.pageIndicatorTintColor = UIColor(hex: "#01A991ff")
        pageControl.currentPageIndicatorTintColor = .black
        return pageControl
    }()
    
    var flightsDetails = [FlightsDetails]()
    
    var page = 0
    var dateFrom = "19/4/2021"
    var dateTo = "20/4/2021"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        scrollView.delegate = self
        view.addSubview(spinnerView)
        view.addSubview(scrollView)
        view.addSubview(titleLabel)
        view.addSubview(pageControl)
        pageControl.addTarget(self, action: #selector(pageControlDidChange(_:)), for: .valueChanged)
        spinnerView.startAnimating()
        spinnerView.hidesWhenStopped = true
        startLoading()
    }
    
    override func viewWillLayoutSubviews() {
        spinnerView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        titleLabel.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.frame.size.width, height: 40)
        scrollView.frame = CGRect(x: 0, y: view.safeAreaInsets.top + titleLabel.frame.size.height + 20, width: view.frame.size.width, height: view.frame.size.height)
        pageControl.frame = CGRect(x: 0, y: view.frame.size.height - 40, width: view.frame.size.width, height: 20)
    }
    
    @objc private func pageControlDidChange(_ sender: UIPageControl) {
        let current = sender.currentPage
        scrollView.setContentOffset(CGPoint(x: CGFloat(current) * view.frame.size.width, y: 0), animated: true)
    }

    func configureScrollView() {
        scrollView.contentSize = CGSize(width: view.frame.size.width*5, height: scrollView.frame.size.height)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        createPage()
    }
    
    func startLoading() {
        let flightsRequest = FlightsRequest(dateFrom: dateFrom, dateTo: dateTo)
        flightsRequest.getData { [weak self] result in
            switch result {
            case .success(let flights):
                self?.flightsDetails = flights
                DispatchQueue.main.async {
                    self?.configureScrollView()
                    self?.spinnerView.stopAnimating()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func createPage() {
        // Looping through in order to get 5 pages and get correct positions in flightsDetails array
        for x in 0..<5 {

//MARK: - UI elements
            let cityImage: UIImageView = {
                let image = UIImageView()
                image.layer.cornerRadius = 20
                image.contentMode = .scaleAspectFill
                image.clipsToBounds = true
                image.layer.masksToBounds = true
                return image
            }()
            let destinationLabel: UILabel = {
                let label = UILabel()
                label.text = "Destination"
                label.font = UIFont.boldSystemFont(ofSize: 25)
                label.textColor = .white
                return label
            }()
            let priceLabel: UILabel = {
                let label = UILabel()
                label.font = UIFont.boldSystemFont(ofSize: 25)
                label.textColor = .white
                label.textAlignment = .right
                return label
            }()
            let fromLabel: UILabel = {
                let label = UILabel()
                label.textColor = .white
                label.text = "From"
                return label
            }()
            let toLabel: UILabel = {
                let label = UILabel()
                label.textColor = .white
                label.text = "To"
                label.textAlignment = .right
                return label
            }()
            let cityCodeFromLabel: UILabel = {
                let label = UILabel()
                label.textColor = .white
                label.font = UIFont.boldSystemFont(ofSize: 25)
                return label
            }()
            let cityCodeToLabel: UILabel = {
                let label = UILabel()
                label.textColor = .white
                label.font = UIFont.boldSystemFont(ofSize: 25)
                label.textAlignment = .right
                return label
            }()
            let fullCityFromNameLabel: UILabel = {
                let label = UILabel()
                label.textColor = .white
                return label
            }()
            let fullCityToNameLabel: UILabel = {
                let label = UILabel()
                label.textColor = .white
                label.textAlignment = .right
                return label
            }()
            let lineView: UIView = {
                let line = UIView()
                line.backgroundColor = .white
                return line
            }()
            let imageView: UIImageView = {
                let image = UIImageView()
                image.image = UIImage(systemName: "airplane")
                image.tintColor = .white
                return image
            }()
            let bookButton: UIButton = {
                let button = UIButton()
                button.layer.cornerRadius = 25
                button.setTitle("Book now", for: .normal)
                button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
                button.layer.borderWidth = 2
                button.layer.borderColor = UIColor(hex: "#01A991ff")?.cgColor
                button.setTitleColor(UIColor(hex: "#01A991ff"), for: .normal)
                return button
            }()
            let flightDetailsView: UIView = {
                let view = UIView()
                view.layer.opacity = 1.0
                view.backgroundColor = UIColor(hex: "#01A991ff")
                view.layer.cornerRadius = 20
                return view
            }()
            let timeLabel: UILabel = {
                let label = UILabel()
                label.textColor = .white
                label.textAlignment = .center
                return label
            }()
            
            let pageView = UIView(frame: CGRect(x: 20, y: 0, width: view.frame.size.width - 40, height: view.frame.size.height - 140))
            
            let page = UIView(frame: CGRect(x: CGFloat(x) * view.frame.size.width, y: 0, width: view.frame.size.width, height: view.frame.size.height))
            
            
//MARK: - Framing UI elements
            cityImage.frame = CGRect(x: 20, y: 0, width: view.frame.size.width - 40, height: (view.frame.size.height / 2) - 40)
            let gradientFrame = CGRect(x: -20, y: 150, width: view.frame.size.width, height: cityImage.frame.size.height - 150)
            flightDetailsView.frame = CGRect(x: 20, y: cityImage.frame.size.height + 20, width: view.frame.size.width - 40, height: 150)
            destinationLabel.frame = CGRect(x: 40, y: cityImage.frame.size.height - 60, width: 120, height: 40)
            priceLabel.frame = CGRect(x: view.frame.size.width - 160, y: cityImage.frame.size.height - 60, width: 120, height: 40)
            fromLabel.frame = CGRect(x: 20, y: 20, width: 100, height: 20)
            toLabel.frame = CGRect(x: view.frame.size.width - 160, y: 20, width: 100, height: 20)
            cityCodeFromLabel.frame = CGRect(x: 20, y: 55, width: 60, height: 40)
            cityCodeToLabel.frame = CGRect(x: view.frame.size.width - 160, y: 55, width: 100, height: 40)
            fullCityFromNameLabel.frame = CGRect(x: 20, y: 100, width: 100, height: 40)
            fullCityToNameLabel.frame = CGRect(x: view.frame.size.width - 160, y: 100, width: 100, height: 40)
            lineView.frame = CGRect(x: ((flightDetailsView.frame.size.width / 2) / 2), y: 74, width: flightDetailsView.frame.size.width / 2, height: 2)
            imageView.frame = CGRect(x: (flightDetailsView.frame.size.width / 2) - 20, y: (flightDetailsView.frame.size.height / 2) - 20, width: 40, height: 40)
            timeLabel.frame = CGRect(x: (flightDetailsView.frame.size.width / 2) - 30, y: 120, width: 60, height: 20)
            bookButton.frame = CGRect(x: view.frame.midX - 80, y: cityImage.frame.size.height + flightDetailsView.frame.size.height + 40, width: 160, height: 50)
            
//MARK: - Subviews adding
            
            scrollView.addSubview(page)
            page.addSubview(pageView)
            page.addSubview(cityImage)
            cityImage.addGradient(frame: gradientFrame)
            page.addSubview(destinationLabel)
            page.addSubview(priceLabel)
            page.addSubview(flightDetailsView)
            flightDetailsView.addSubview(fromLabel)
            flightDetailsView.addSubview(toLabel)
            flightDetailsView.addSubview(cityCodeFromLabel)
            flightDetailsView.addSubview(cityCodeToLabel)
            flightDetailsView.addSubview(fullCityFromNameLabel)
            flightDetailsView.addSubview(fullCityToNameLabel)
            flightDetailsView.addSubview(lineView)
            flightDetailsView.addSubview(imageView)
            flightDetailsView.addSubview(timeLabel)
            page.addSubview(bookButton)
            
            
//MARK: - Managing data
            
            let cityId = flightsDetails[x].mapIdto
            let url = URL(string: "https://images.kiwi.com/photos/600x330/\(cityId).jpg")
            let priceString = "Price: " + String(flightsDetails[x].price) + "€"
            
            if let safeURL = url {
                cityImage.load(url: safeURL)
            }
            
            timeLabel.text = getDepartureTime(for: x)
            fullCityFromNameLabel.text = self.flightsDetails[x].cityFrom
            fullCityToNameLabel.text = self.flightsDetails[x].cityTo
            cityCodeFromLabel.text = self.flightsDetails[x].cityCodeFrom
            cityCodeToLabel.text = self.flightsDetails[x].cityCodeTo
            destinationLabel.text = self.flightsDetails[x].cityTo
            priceLabel.text = priceString
            
            bookButton.addTarget(self, action: #selector(didTapBookButton), for: .touchUpInside)
            
        }
    }
    
    @objc func didTapBookButton() {
        if let url = URL(string: flightsDetails[page].deep_link),
                UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:])
        } else {
            print("Bad link.")
        }
    }
    
    func getDate() {
        let today = Date()
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today) ?? today
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/mm/YYYY"
        let todayString = formatter.string(from: today)
        let tomorrowString = formatter.string(from: tomorrow)
        dateFrom = todayString
        dateTo = tomorrowString
    }
    
    func getDepartureTime(for x: Int) -> String {
        let time = Date(timeIntervalSince1970: TimeInterval(flightsDetails[x].dTime))
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let timeString = formatter.string(from: time)
        return timeString
    }
    
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(floorf(Float(scrollView.contentOffset.x) / Float(scrollView.frame.size.width)))
        page = pageControl.currentPage
    }
}

