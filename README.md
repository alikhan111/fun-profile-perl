# Fun Profile - Perl CGI Script

A simple interface in which a user enters their details (name, email, DOB).  
A Perl CGI script processes the information and calculates the user's age & provides fun details based on DOB.  

This includes:
1. Age in years, months, weeks, days, hours, and minutes.  
2. The zodiac sign.  
3. Their generation name.  

## How It Works
- The user fills out a form (`index.html`).
- The Perl script (`fun-profile.pl`) processes the input and generates a response page.
- Proper validation ensures correct inputs.

## Requirements
- Perl with `CGI.pm` and `DateTime` module installed.
- A web server with CGI execution enabled.

## Usage
1. Upload `index.html` and `fun-profile.pl` to your server.
2. Ensure the Perl script has execute permissions:  
   sh
   chmod +x fun-profile.pl
