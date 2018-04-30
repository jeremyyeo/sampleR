// Jeremy Yeo's simple Apps Script open counter for google sheet.
// If the current UTC date already exists, it will just increase the number.
// If the current UTC date does not exists, it will be added as a new row.

// 1. Create a new worksheet called "COUNTER_DO_NOT_EDIT" with only 2 columns and 1 row.
// 2. Name the first column Date and the second column Views.
// 3. Lock the permissions to every sheet except the "COUNTER_DO_NOT_EDIT" sheet.
// 4. Make the whole worksheet editable.
// 5. In your Google Sheet, go to Tools > Script editor... and paste this whole code.
// 6. Run this script and look in your worksheet. 
//    P.S. there may be some permission prompts that appear on the first run.

function onOpen() {
  var ss        = SpreadsheetApp.getActiveSpreadsheet();
  var sh        = ss.getSheetByName("COUNTER_DO_NOT_EDIT");
  var today     = getFormattedUTCDate();

  var aa        = sh.getRange("A:A").getDisplayValues();
  var aa_length = aa.length;
  var aa_last   = aa.pop()[0];
  
  var bb        = sh.getRange("B:B").getValues();
  var bb_length = bb.length;
  var bb_last   = Number(bb.pop());
  
  if (bb_last == null) {bb_last = 0;}
  
  // if the current date already exists,
  // update the most recent view count,
  // else create a new row.
  if (aa_last == today) {
    var cell  = "B" + bb_length;
    var value = bb_last + 1;
    sh.getRange(cell).setValue(value);
  } else {
    var cell_a = "A" + String(aa_length + 1);
    var cell_b = "B" + String(bb_length + 1);
    sh.getRange(cell_a).setValue(today);
    sh.getRange(cell_b).setValue(1);
  }
}

function getFormattedUTCDate() {
  var today = new Date();
  var dd    = today.getUTCDate();
  var mm    = today.getUTCMonth() + 1;
  var yyyy  = today.getUTCFullYear();
  if (dd < 10) {dd = "0" + dd;}
  if (mm < 10) {mm = "0" + mm;}
  today = yyyy + "-" + mm + "-" + dd;
  return today;
}

// Recording Spreadsheet views as pageviews in Google Analytics.

function GOOGLEANALYTICS(gaaccount) {
    var spreadsheetName = SpreadsheetApp.getActiveSpreadsheet().getName();
    var sheetName = SpreadsheetApp.getActiveSpreadsheet().getActiveSheet().getName(); 

    /** 
    * Written by Amit Agarwal 
    * Web: www.ctrlq.org 
    * Email: amit@labnol.org 
    */ 

    // https://developers.google.com/analytics/devguides/collection/protocol/v1/reference
    var imageURL = [
      "//ssl.google-analytics.com/collect?v=1&t=pageview",
      "&tid=" + gaaccount,
      "&cid=" + Utilities.getUuid(),
      "&z="   + Math.round(Date.now() / 1000).toString(),
      "&dp="  + encodeURIComponent(spreadsheetName + " - " + sheetName)
    ].join("");
    
    return imageURL;
  }
