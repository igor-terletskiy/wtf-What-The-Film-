//
//  CalendarVar.swift
//  FirstPagePosterApp
//
//  Created by Igor on 06.08.2018.
//  Copyright © 2018 Gargolye. All rights reserved.
//

import Foundation

let date = Date()
let calendar = Calendar.current
var day = calendar.component(.day, from: date)
var weekday = calendar.component(.weekday, from: date) - 1
var month = calendar.component(.month, from: date) - 1
var year = calendar.component(.year, from: date)
var Months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
let DaysOfMounth = ["Monday", "Thuesday", "Wednesday", "Thursday", "Firday", "Satuday", "Sunday"]
var DaysInMonths = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
var currentMonth = String()
var nextNumerOfEmptyBox = Int()//the same whit above but with the next month
var numerOfEmptyBox  = Int() // The number of "empty boxes" at the start of the current month
var previousNumberOfEmptyBox = 0// the same whit the prev mouth
var direction = 0 // = 0 if we are at the current month , =1 if we are in a futuremonth, =-1 if we are in a past mont
var positionINdex = 0 // here we well store the above vars of the empty boxes
//var LeapYearCounter = 2 // it's  2 because the next time february has 29 bay's is in two years (it happens evry 4 - year's )
var dayCounter = 0
