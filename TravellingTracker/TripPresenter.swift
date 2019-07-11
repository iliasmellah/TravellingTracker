//
//  TripPresenter.swift
//  TravellingTracker
//
//  Created by user154076 on 7/11/19.
//  Copyright © 2019 user154076. All rights reserved.
//

import Foundation

class TripPresenter: NSObject {
    fileprivate var name : String = ""
    fileprivate var color : String = ""
    /*
    fileprivate var startDate : String = ""
    fileprivate var endDate : String = ""
     */
    
    fileprivate var trip : Trip? = nil {
        didSet {
            
            if let trip = self.trip {
                
                //met à jour les données d'affichage
                let xname = trip.name
                if xname == "" {
                    self.name = " - "
                } else {
                    self.name = xname!.capitalized
                }
                
                let xcolor = trip.color
                if xcolor == "" {
                    self.color = " Grey "
                } else {
                    self.color = xcolor!.capitalized
                }
                
                /*if let xname = trip.name {
                    self.name = xname.capitalized
                } else {
                    self.name = " - "
                }
                
                if let xcolor = trip.color {
                    self.color = xcolor.capitalized
                } else {
                    self.color = "GREY"
                }
                
                if let xStartDate = trip.dateStart {
                    self.startDate = Date.toString(date: xStartDate).capitalized
                } else {
                    self.startDate = Date.toString(date: Date.currentDate()).capitalized
                }
                
                if let xEndDate = trip.dateEnd {
                    self.endDate = Date.toString(date: xEndDate).capitalized
                } else {
                    self.endDate = Date.toString(date: Date.currentDate()).capitalized
                }*/
                

                
            } else {
                self.name = ""
                self.color = ""
                
                /*self.startDate = ""
                self.endDate = ""*/
            }
        }
    }
    
    func configure(theCell : TripTableViewCell?, forTrip : Trip?) {
        self.trip = forTrip
        guard let cell = theCell else { return }
        cell.nameTripLabel.text = self.name
        cell.colorTripLabel.text = self.color
    }
}
