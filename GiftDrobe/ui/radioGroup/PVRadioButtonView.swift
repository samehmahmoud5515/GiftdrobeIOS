//
//  PVRadioButtonView.swift
//  GiftDrobe
//
//  Created by Logic Designs on 4/3/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//
import UIKit
protocol radioButtonClickedTableDelegate {
    func radioButtunClickedInTable(button: PVRadioButton)
}
class PVRadioButtonView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    var tableView: UITableView!
    var delegate: radioButtonClickedTableDelegate!
    var radioButtonGroup: PVRadioButtonGroup!
    var radioButtons:[PVRadioButton]!
    
    @IBInspectable var cellHeight:CGFloat = 44 {
        didSet{
            self.tableView.reloadData()
        }
    }
    @IBInspectable var radioButtonColor:UIColor = UIColor.black{
        didSet{
            self.tableView.reloadData()
        }
    }
    @IBInspectable var titleColor:UIColor = UIColor.black{
        didSet{
            self.tableView.reloadData()
        }
    }
    
    @IBInspectable var titleSize:CGFloat = 20 {
        didSet{
            self.tableView.reloadData()
        }
    }
    
    @IBInspectable var cellBackGroudColor:UIColor = UIColor.blue{
        didSet{
            self.tableView.reloadData()
        }
    }
    @IBInspectable var isScrollable:Bool = true {
        didSet{
            self.tableView.isScrollEnabled = isScrollable
        }
    }
    @IBInspectable var textAndRadioButtonGap:CGFloat = 10 {
        didSet{
            self.tableView.reloadData()
        }
    }
    @IBInspectable var showSeperator:Bool = true {
        didSet{
            if showSeperator {
                tableView.separatorStyle = .singleLine
            } else {
                tableView.separatorStyle = .none
            }
            self.tableView.reloadData()
        }
    }
    
    @IBInspectable var headerText:String = "" {
        didSet{
            if headerText != ""{
                setHeaderForTableView()
            }
        }
    }
    @IBInspectable var headerColor:UIColor = UIColor.blue {
        didSet{
            setHeaderForTableView()
        }
    }
    
    @IBInspectable var headerSize:CGFloat = 30 {
        didSet{
            setHeaderForTableView()
        }
    }
    
    
    @IBInspectable var headerfontSize:CGFloat = 10 {
        didSet{
            setHeaderForTableView()
        }
    }
    
    
    
    var radioButtonTitles = [String]()
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    // MARK: init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        tableView = UITableView()
        tableView.frame = self.bounds
        tableView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        tableView.delegate = self
        tableView.dataSource = self
        radioButtons = [PVRadioButton]()
        self.addSubview(tableView)
    }
    
    func addButtons(radioButtonTitles: [String]) {
        self.radioButtonTitles = radioButtonTitles
        if showSeperator {
            tableView.separatorStyle = .singleLine
        } else {
            tableView.separatorStyle = .none
        }
        for radioButtonTitle in radioButtonTitles {
            let radioButton = PVRadioButton()
            radioButton.buttonTitle = radioButtonTitle
            radioButton.buttonTitleColor = titleColor
            radioButton.radioButtoncolor = radioButtonColor
            radioButton.buttonTitleSize = titleSize
            radioButton.spaceBetweenTextAndRadioButton = textAndRadioButtonGap
            radioButton.contentHorizontalAlignment = .left
            radioButton.autoresizingMask = [.flexibleWidth,.flexibleHeight]
            radioButton.addTarget(self, action: #selector(PVRadioButtonGroup.updateButtons(button:)), for:UIControlEvents.touchUpInside)
            radioButtons.append(radioButton)
        }
        setHeightOfCellIfScrollingIsDisabled()
        self.tableView.reloadData()
        
    }
    
    func setHeaderForTableView() {
        let headerView: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: headerSize))
        let headerLabel: UILabel = UILabel.init(frame: CGRect(x: 16, y: 0, width: tableView.bounds.width, height: headerSize))
        headerLabel.text = headerText
        headerLabel.textColor = headerColor
        headerLabel.font = UIFont.boldSystemFont(ofSize: headerfontSize)
        headerView.addSubview(headerLabel)
        self.tableView.tableHeaderView = headerView
    }
    
    func setHeightOfCellIfScrollingIsDisabled()  {
        if !isScrollable {
            cellHeight = self.bounds.height/CGFloat(radioButtonTitles.count)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(cellHeight)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return radioButtonTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let radioButton = radioButtons[indexPath.row]
        radioButton.frame = cell.contentView.bounds
        cell.contentView.backgroundColor = cellBackGroudColor
        cell.contentView.addSubview(radioButton)
        return cell
    }
    
    @objc func updateButtons(button:PVRadioButton) {
        for lbutton in radioButtons {
            if lbutton != button {
                lbutton.isRadioSelected = false
            } else {
                lbutton.isRadioSelected = true
            }
        }
        delegate?.radioButtunClickedInTable(button: button)
    }
    
    
}

