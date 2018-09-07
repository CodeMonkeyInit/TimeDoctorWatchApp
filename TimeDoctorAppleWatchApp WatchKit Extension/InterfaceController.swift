//
//  InterfaceController.swift
//  TimeDoctorAppleWatchApp WatchKit Extension
//
//  Created by Денис Кулиев on 14.08.2018.
//  Copyright © 2018 Денис Кулиев. All rights reserved.
//

import WatchKit
import Foundation

class TimeDoctorClient{
    var workedLabel: WKInterfaceLabel
    var leftToWorkLabel: WKInterfaceLabel
    var dayEndLabel: WKInterfaceLabel
    
    static var timeToLeave: String = "";
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (hours: Int, minutes: Int, seconds: Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    init(workedLabel : WKInterfaceLabel,
         leftToWorkLabel: WKInterfaceLabel,
         dayEndLabel: WKInterfaceLabel) {
        
        self.workedLabel = workedLabel
        self.leftToWorkLabel = leftToWorkLabel
        self.dayEndLabel = dayEndLabel
    }
    
    func updateWorkedTime(){
        let date = Date();
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let currentDateFormatted = dateFormatter.string(from: date)
        
        let accessToken = "ZjlhNGZlY2RiNDFmOGMyNWM3NzdmMTVjYmYzYzMyMGMxYzFjZWM5ZGQ3MzE0NGE4ZDNmYzgzY2YxN2FkNTY5Yg";
        
        let url = URL(string: "https://webapi.timedoctor.com/v1.1/companies/262915/worklogs?access_token=\(accessToken)&_format=json&start_date=\(currentDateFormatted)&end_date=\(currentDateFormatted)")!;
        
        let getRequest = URLRequest(url: url)
        
        let urlSession = URLSession.shared
        
        let task = urlSession.dataTask(with: getRequest, completionHandler: {data, response, error in
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {

                    let totalSeconds = json["total"] as! Int
                    
                    self.updateLabels(seconds: totalSeconds)
                }
            } catch let error {
                debugPrint(error.localizedDescription)
            }
        })
        
        task.resume()
    }
    
    fileprivate func updateLabels(seconds: Int) {
        let timeToWork = 8 * 60 * 60
        
        let timeLeft =  timeToWork - seconds
        
        let calendar  = Calendar.current
        
        let workDayEnd: Date = calendar.date(byAdding: .second, value: timeLeft, to: Date())!
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "HH:mm"
        
        let hoursMinutesSeconds = self.secondsToHoursMinutesSeconds(seconds: seconds)
        let leftToWork = self.secondsToHoursMinutesSeconds(seconds: timeLeft)
        
        self.leftToWorkLabel.setText("\(leftToWork.hours):\(leftToWork.minutes)")
        self.workedLabel.setText("\(hoursMinutesSeconds.hours):\(hoursMinutesSeconds.minutes)")
        self.dayEndLabel.setText(dateFormatter.string(from: workDayEnd))
        
        TimeDoctorClient.timeToLeave = dateFormatter.string(from: workDayEnd)
    }
}

class InterfaceController: WKInterfaceController {

    @IBOutlet var dateLabel: WKInterfaceLabel!
    @IBOutlet var leftToWorkLabel: WKInterfaceLabel!
    @IBOutlet var dayEndLabel: WKInterfaceLabel!
    
    var timeDoctorClient: TimeDoctorClient!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        timeDoctorClient = TimeDoctorClient(workedLabel: dateLabel, leftToWorkLabel: leftToWorkLabel, dayEndLabel: dayEndLabel)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        super.willActivate()
        
        timeDoctorClient.updateWorkedTime()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
