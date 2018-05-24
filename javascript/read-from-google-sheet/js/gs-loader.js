// Client ID and API key from the Developer Console
var CLIENT_ID = '472449861955-ag4d3emr7mqp0hndji54ngu6aknrh176.apps.googleusercontent.com';
var API_KEY = 'AIzaSyBW0wj7LWIzY2Jni07FLDirHa45R7urZEE';
// Array of API discovery doc URLs for APIs used by the quickstart
var DISCOVERY_DOCS = ["https://sheets.googleapis.com/$discovery/rest?version=v4"];
// Authorization scopes required by the API; multiple scopes can be
// included, separated by spaces.
var SCOPES = "https://www.googleapis.com/auth/spreadsheets.readonly";
var authorizeButton = document.getElementById('authorize-button');
var signoutButton = document.getElementById('signout-button');
var commentary = document.getElementById('commentary');
/**
 *  On load, called to load the auth2 library and API client library.
 */
function handleClientLoad() {
  gapi.load('client:auth2', initClient);
}

/**
 *  Initializes the API client library and sets up sign-in state
 *  listeners.
 */
function initClient() {
  gapi.client.init({
    apiKey: API_KEY,
    clientId: CLIENT_ID,
    discoveryDocs: DISCOVERY_DOCS,
    scope: SCOPES
  }).then(function () {
    // Listen for sign-in state changes.
    gapi.auth2.getAuthInstance().isSignedIn.listen(updateSigninStatus);
    // Handle the initial sign-in state.
    updateSigninStatus(gapi.auth2.getAuthInstance().isSignedIn.get());
    authorizeButton.onclick = handleAuthClick;
    signoutButton.onclick = handleSignoutClick;
  });
}

/**
 *  Called when the signed in status changes, to update the UI
 *  appropriately. After a sign-in, the API is called.
 */
function updateSigninStatus(isSignedIn) {
  if (isSignedIn) {
    authorizeButton.style.display = 'none';
    signoutButton.style.display = 'block';
    commentary.style.display = 'block';
    document.getElementById('content').textContent = '';
    mainPlotDrawer();
    // listMajors();
  } else {
    authorizeButton.style.display = 'block';
    signoutButton.style.display = 'none';
    commentary.style.display = 'none';
  }
}

/**
 *  Sign in the user upon button click.
 */
function handleAuthClick(event) {
  gapi.auth2.getAuthInstance().signIn();
  console.log('User signed in.');
  document.getElementById('content').textContent = '';
}

/**
 *  Sign out the user upon button click.
 */
function handleSignoutClick(event) {
  gapi.auth2.getAuthInstance().signOut();
  console.log('User signed out.');
  document.getElementById('content').textContent = 'Authorize to view the data.';
  var plot = document.getElementById('score-plot');
  plot.removeChild(plot.childNodes[0]);
  var plot = document.getElementById('trend-plot');
  plot.removeChild(plot.childNodes[0]);
}

/**
 * Append a pre element to the body containing the given message
 * as its text node. Used to display the results of the API call.
 *
 * @param {string} message Text to be placed in pre element.
 */
function appendPre(message) {
  var pre = document.getElementById('content');
  var textContent = document.createTextNode(message + '\n');
  pre.appendChild(textContent);
}

/**
 * Print the names and majors of students in a sample spreadsheet:
 * https://docs.google.com/spreadsheets/d/1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms/edit
 * spreadsheetId: '1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms',
 * spreadsheetId: '1rl4lCMZ7xfPUthbJIQp3_6vyKbjbcpg6b7paPcugW0o',
 */
function listMajors() {
  var sheetsId = String(document.querySelector('#inputSheetsId').value);
  var range;
  if (sheetsId == '1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms') {
    range = 'Class Data!A2:E';
  } else {
    range = 'Sheet1!A:B';
  }
  gapi.client.sheets.spreadsheets.values.get({
    spreadsheetId: sheetsId,
    range: range,
  }).then(function(response) {
    var range = response.result;
    if (range.values.length > 0) {
      // appendPre('Name, Major:');
      for (i = 0; i < range.values.length; i++) {
        var row = range.values[i];
        // Print columns A and E, which correspond to indices 0 and 4.
        appendPre(row[0] + ', ' + row[1]);
      }
    } else {
      appendPre('No data found.');
    }
  }, function(response) {
    appendPre('Error: ' + response.result.error.message);
  });
}

function requestObject(sheetsId, range) {
  var params = {spreadsheetId: sheetsId, range: range};
  var request = gapi.client.sheets.spreadsheets.values.get(params);
  return request;
}

function mainPlotDrawer() {
//   var sheetsId = String(document.querySelector('#inputSheetsId').value);
  var sheetsId = '1rl4lCMZ7xfPUthbJIQp3_6vyKbjbcpg6b7paPcugW0o';
  var sheetsRange = String(document.getElementById('region').value) + '!A:C'
  document.getElementById('region-name').textContent = String(document.getElementById('region').value);
//   var sheetsRange = String(document.querySelector('#inputSheetsRange').value);
  requestObject(
    sheetsId,
    sheetsRange
  ).then(function(response) {
     var data = response.result.values;
     var xDate = [];
     var yTrace0 = [];
     var yTrace1 = [];
     for (i = 0; i < data.length; i++) {
       var row = data[i];
       xDate.push(row[0]);
       yTrace0.push(row[1]);
       yTrace1.push(row[2]);
     }
     console.log(xDate);
     console.log(yTrace0);
     console.log(yTrace1);
     
     // Draw the main trends plot.
     drawTrendPlot(xDate, yTrace0);
     addTrendPlot(xDate, yTrace1);

     // Draw the brand vibrancy plot.
     drawScorePlot(xDate, yTrace0, yTrace1);

     // Empty content print out if successful.
     var content = document.getElementById('content');
     content.textContent = '';
  }, function(response) {
    var content = document.getElementById('content');
    content.setAttribute('style', 'font-weight: bold;');
    content.textContent = 'Error: ' + response.result.error.message + '.';
  });
}

function getRaw() {
  requestObject(
    '1rl4lCMZ7xfPUthbJIQp3_6vyKbjbcpg6b7paPcugW0o',
    'Sheet1!A2:A'
  ).then((response) => {
    var values = response.result.values;
    values = [].concat.apply([], values); 
    sessionStorage.setItem('dateValues', JSON.stringify(values));
  });
  requestObject(
    '1rl4lCMZ7xfPUthbJIQp3_6vyKbjbcpg6b7paPcugW0o', 
    'Sheet1!B2:B'
  ).then((response) => {
    var values = response.result.values;
    values = [].concat.apply([], values); 
    values = values.map(Number);
    sessionStorage.setItem('trendValues', JSON.stringify(values));
  });
}

function printRaw() {
  // Prints data to console for debugging.
  console.log(JSON.parse(sessionStorage.getItem('dateValues')));
  console.log(JSON.parse(sessionStorage.getItem('trendValues')));
}

// Draw the initial plot.
function drawTrendPlot(x, y) {
  name = y[0];
  y = y.map(Number);
  PLOT = document.getElementById('trend-plot');

  var trace1 = {
    x: x,
    y: y,
    type: 'scatter',
    name: name,
    marker: {color: brandColor(name)}
  };

  var layout = {
    showlegend: true,
    margin: {t: 0},
    legend: {'orientation': 'h'}
  };

  Plotly.newPlot(PLOT, [trace1], layout, {displayModeBar: false});
}

// Add a new trace to an existing plot.
function addTrendPlot(x, y) {
  name = y[0];
  y = y.map(Number);
  PLOT = document.getElementById('trend-plot');

  var trace1 = {
    x: x,
    y: y,
    type: 'scatter',
    name: name,
    marker: {color: brandColor(name)}
  };

  Plotly.plot(PLOT, [trace1]);
}

function drawScorePlot(x, yTrace0, yTrace1) {
  name = 'Brand vibrancy score';
  PLOT = document.getElementById('score-plot');
  
  yTrace0 = yTrace0.map(Number);
  yTrace1 = yTrace1.map(Number);

  var y = [];
  for (i = 0; i < yTrace0.length; i++) {
    y.push(yTrace0[i] / yTrace1[i]);
  }

  var trace1 = {
    x: x,
    y: y,
    type: 'scatter',
    name: name,
    marker: {color: '#45474D'}
  };

  var layout = {
    showlegend: true,
    legend: {'orientation': 'h'},
    margin: {t: 0},
    shapes: [{
      type: 'line',
      x0: 0,
      x1: 1,
      y0: 1,
      y1: 1,
      xref: 'paper',
      line: {
        color: '#45474D',
        width: 1.5,
        dash: 'dot'
      }
    }]
  };

  Plotly.newPlot(PLOT, [trace1], layout, {displayModeBar: false});
  
  // Update text with latest score and growth in score.
  var latestScore = y[y.length - 1].toFixed(2);
  
  var latestScoreMom = (latestScore - y[y.length - 2]) / y[y.length - 2] * 100;
  latestScoreMom = latestScoreMom.toFixed(2);

  var latestScoreYoy = (latestScore - y[y.length - 13]) / y[y.length - 13] * 100;
  latestScoreYoy = latestScoreYoy.toFixed(2);

  document.getElementById('current-score').textContent = latestScore;
  if (latestScore >= 0) {
    document.getElementById('current-score').setAttribute('style', 'color: green');
  } else {
    document.getElementById('current-score').setAttribute('style', 'color: red');
  }

  document.getElementById('current-score-mom').textContent = latestScoreMom + '%';
  if (latestScoreMom <= 0) {
    document.getElementById('current-score-mom').setAttribute('style', 'color: red');
  } else {
    document.getElementById('current-score-mom').setAttribute('style', 'color: green');
  }
  
  document.getElementById('current-score-yoy').textContent = latestScoreYoy + '%';
  if (latestScoreYoy <= 0) {
    document.getElementById('current-score-yoy').setAttribute('style', 'color: red');
  } else {
    document.getElementById('current-score-yoy').setAttribute('style', 'color: green');
  }  
}

function brandColor(brand) {
  var colors = {};
  colors['Xero'] = '#13B5EA';
  colors['MYOB'] = '#5C247B';
  colors['Sage Group'] = '#007F64';
  colors['QuickBooks'] = '#2CA01C';
  return colors[brand];
}

document.getElementById('region').onchange = function() {
//   console.log(this.value);
  mainPlotDrawer();
}
