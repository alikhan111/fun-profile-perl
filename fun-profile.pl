#!/usr/bin/perl 
use strict;
use warnings;
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);
use Time::Piece;
use DateTime;
use HTTP::Tiny;
use JSON;
use Email::Valid;

##################################
# Perl Script Created By Ali Khan
##################################

# User Input Variables
my ($name, $email, $day, $month, $year);
my ($years, $months, $weeks, $days, $hours, $minutes);
my ($generation, $starsign);
my $dob;
my $current_date;
my $start_date;
my $days_difference;

# Run the script
&collect_data();
&validate_input();
&date_objects();
#&date_difference_delta();
&date_difference_md();
$starsign   = get_star_sign($day, $month);
$generation = get_generation($year);

# Print results page
&html_head();
&get_page();
&html_exit();

# Collect user data
sub collect_data 
{
    my $cgi = CGI->new;
    
    # Data entry from user
    $name    = $cgi->param("name");
    $email   = $cgi->param("email");
    $day     = $cgi->param("day");
    $month   = $cgi->param("month");
    $year    = $cgi->param("year");

    $dob = "$day-$month-$year";
    return;
}

# Validate_input email & date
sub validate_input {
    unless (Email::Valid->address($email)) {
        &error_page("Invalid email address! Please enter a correct email.");
    }
    unless (check_date_validity($day, $month, $year)) {
        &error_page("Invalid Date of Birth! Please enter a valid date.");
    }
}

sub error_page {
    my ($message) = @_;
    print "Content-type: text/html\n\n";
    print "<html><body><h3 style='color:red;'>Error: $message</h3></body></html>";
    exit;
}

# Check date validity
sub check_date_validity {
    my ($d, $m, $y) = @_;
    eval { DateTime->new(year => $y, month => $m, day => $d) };
    return $@ ? 0 : 1;
}

# Create DateTime objects
sub date_objects {
    $start_date = DateTime->new(year => $year, month => $month, day => $day);
    $current_date = DateTime->now;
    return;
}

sub date_difference_delta {
    my $duration = $current_date->delta_days($start_date)->in_units('days');
    $years = int($duration / 365);
    $months = int(($duration % 365) / 30);
    $weeks = int($duration / 7);
    $days = $duration % 7;
    $hours = $duration * 24;
    $minutes = $hours * 60;
}

# Calculate age in years, months, weeks, days, hours, minutes  
sub date_difference_md {
    my $duration = $current_date->delta_md($start_date);
    $years = $duration->in_units('years');
    $months = $duration->in_units('months') % 12;
    $days = $duration->in_units('days') % 30;
    $hours = ($years * 365 + $months * 30 + $days) * 24;
    $minutes = $hours * 60;
}

# Deterñmine the Zodiac sign
sub get_star_sign {
    my ($d, $m) = @_;
    my @zodiac_signs = (
        ['Capricorn',  1, 19], ['Aquarius',  2, 18], ['Pisces',  3, 20], 
        ['Aries',  4, 19], ['Taurus',  5, 20], ['Gemini',  6, 20], 
        ['Cancer',  7, 22], ['Leo',  8, 22], ['Virgo',  9, 22], 
        ['Libra', 10, 22], ['Scorpio', 11, 21], ['Sagittarius', 12, 21], 
        ['Capricorn', 12, 31] 
    );

    for my $sign (@zodiac_signs) {
        my ($name, $m_sign, $d_sign) = @$sign;
        return $name if ($m == $m_sign && $d <= $d_sign) || ($m == $m_sign - 1 && $d > $d_sign);
    }
    return "Unknown";
}

# Determine the Generation
sub get_generation {
    my ($y) = @_;
    return "The Greatest Generation (1901-1924)" if $y >= 1901 && $y <= 1924;
    return "The Silent Generation (1925-1945)" if $y >= 1925 && $y <= 1945;
    return "Baby Boomer Generation (1946-1964)" if $y >= 1946 && $y <= 1964;
    return "Generation X (1965-1979)" if $y >= 1965 && $y <= 1979;
    return "Millennials (1980-1994)" if $y >= 1980 && $y <= 1994;
    return "Generation Z (1995-2012)" if $y >= 1995 && $y <= 2012;
    return "Gen Alpha (2013-2025)" if $y >= 2013 && $y <= 2025;
    return "Unknown Generation";
}

sub html_head
{
	print "Content-type: text/html\n\n";
}

sub html_exit
{
	exit(0);
}

sub get_page
{

print <<__END_OF_HTML_CODE__;

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Fun Profile</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      display: flex;
      justify-content: center;
      align-items: center;
      min-height: 80vh;
      margin: 0;
      background-color: #f4f4f4;
    }
    
    .container {
      width: 80%;
      max-width: 430px;
      background: white;
      border-radius: 10px;
      box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
      padding: 30px;
    }
    
    .container img {
      display: block;
      margin: 0 auto 20px;
      width: 100px;
      height: 80px;
    }
  </style>
</head>
<body>
  <div class="container">
    <img src="fun-profile.jpg" alt="Fun Profile Logo">
    <h2>Fun Profile Results</h2>
    <p><strong>Name:</strong> $name</p>
    <p><strong>Email:</strong> $email</p>
    <p><strong>Date of Birth:</strong> $dob</p>
    <p><strong>Zodiac Sign:</strong> $starsign</p>
    <p><strong>Generation:</strong> $generation</p>
    <p><strong>Age in Years:</strong> $years</p>
    <p><strong>Age in Months:</strong> $months</p>
    <p><strong>Age in Weeks:</strong> $weeks</p>
    <p><strong>Age in Days:</strong> $days</p>
    <p><strong>Age in Hours:</strong> $hours</p>
    <p><strong>Age in Minutes:</strong> $minutes</p>
  </div>
</body>
</html>

__END_OF_HTML_CODE__

}