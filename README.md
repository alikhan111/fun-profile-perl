# Fun Profile - Perl CGI Script

A simple interface in which a user enters their details (name, email, DOB).  

![Screenshot 2025-03-15 at 15 15 17](https://github.com/user-attachments/assets/91e9b294-49c2-4ceb-90df-8414aa9d6429)

A Perl CGI script processes the information and calculates the user's age & provides fun details based on DOB.

This includes:
1. Age in years, months, weeks & days.  
2. The zodiac sign.  
3. The generation group.  

![Screenshot 2025-03-15 at 15 15 28](https://github.com/user-attachments/assets/21830987-45df-44d5-a052-61e5423afe28)

## How It Works
- The user fills out a form (`index.html`).
- The Perl script (`fun-profile.pl`) processes the input and generates a response page.
- Make sure the Perl script is placed within the cgi-bin folder. 
- Proper validation ensures correct inputs.

## Requirements
- Perl with `CGI.pm` and `DateTime` module installed.
- A web server with CGI execution enabled.

How to install perl modules:
1. Open terminal
2. Type the following:
   
   perl -MCPAN -e shell
   install DateTime
   install CGI
   exit

Test the module in Perl:

   perl -e 'use DateTime; print "DateTime module installed successfully\n";'
   
   perl -e 'use CGI; print "DateTime module installed successfully\n";'


## Usage
1. Upload `index.html` and `fun-profile.pl` to your server.
2. Ensure the Perl script has execute permissions:  
   sh
   chmod +x fun-profile.pl
