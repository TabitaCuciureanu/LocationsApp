//
//  LocationListViewController.swift
//  Locations App
//
//  Created by Tabita Marusca on 01/11/2020.
//  Copyright © 2020 Tabita Marusca. All rights reserved.
//

import UIKit
import FSPagerView
import Nuke

final class LocationListViewController: UIViewController, FSPagerViewDataSource, FSPagerViewDelegate {
    // MARK: - Properties
    
    private let pagerView = FSPagerView(frame: .zero)

    private let viewModel: LocationListViewModel
    private let router: Router
    
    // MARK: - Init

    init(viewModel: LocationListViewModel, router: Router) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewController Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.getLocations()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor  = .systemBackground
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem = addButton
        
        setupPagerView()
        viewModel.locationsDidUpdate = { [pagerView] in
            DispatchQueue.main.async {
                pagerView.reloadData()
            }
        }
    }
    
    // MARK: - PagerView
    
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return viewModel.locations?.count ?? 0
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        
        guard let locations = viewModel.locations else { return cell }
        
        guard !locations[index].image.isEmpty,
            let url = URL(string: locations[index].image),
            let imageView = cell.imageView else {
                cell.imageView?.image = viewModel.placeholderImage
                cell.textLabel?.text = viewModel.cellTextFor(index: index)
                return cell
        }
        
        imageView.contentMode = .scaleAspectFit
        
        let request = ImageRequest(url: url)
        Nuke.loadImage(with: request, into: imageView)
        
        cell.textLabel?.text = viewModel.cellTextFor(index: index)
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        guard let locations = viewModel.locations else { return }
        router.goToDetailsScreen(location: locations[index])
        pagerView.deselectItem(at: index, animated: true)
    }
    
    // MARK: - Private Methods
    
    @objc private func addTapped() {
        router.goToAddNewLocationScreen()
    }
    
    private func setupPagerView() {
        setupImageLoadingOptions()
        setupCache()
        
        pagerView.dataSource = self
        pagerView.delegate = self
        pagerView.transformer = FSPagerViewTransformer(type: .linear)
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        pagerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(pagerView)
        
        let pageControl = FSPageControl(frame: .zero)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pagerView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            pagerView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            pagerView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            
            pageControl.topAnchor.constraint(equalTo: pagerView.bottomAnchor, constant: 20),
            pageControl.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
    }
    
    private func setupCache() {
        DataLoader.sharedUrlCache.diskCapacity = 0
        let pipeline = ImagePipeline {
            let dataCache = try? DataCache(name: "com.tabita.Locations-App.datacache")
            dataCache?.sizeLimit = 200 * 1024 * 1024 // 200 MB 
            $0.dataCache = dataCache
        }
        
        ImagePipeline.shared = pipeline
    }
    
    private func setupImageLoadingOptions() {
        let contentModes = ImageLoadingOptions.ContentModes(
            success: .scaleAspectFit,
            failure: .scaleAspectFit,
            placeholder: .scaleAspectFit)
        ImageLoadingOptions.shared.contentModes = contentModes
        ImageLoadingOptions.shared.failureImage = viewModel.placeholderImage
        ImageLoadingOptions.shared.transition = .fadeIn(duration: 0.5)
    }
}
