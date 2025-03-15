#!/usr/bin/perl
use strict;
use warnings;
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);
use DateTime;
use Email::Valid;

##################################
# Perl Script Created By Ali Khan
##################################

# Declare global variables
my ($name, $email, $day, $month, $year);
my ($years, $months, $weeks, $days, $hours, $minutes);
my ($generation, $starsign);
my ($dob, $current_date, $start_date);

# Collect user input and validate
collect_data();
validate_input();

# Check if valid before proceeding
if (!$year || !$month || !$day) {
    error_page("Missing or invalid date input. Please enter a valid date.");
}

# Generate DateTime objects
($start_date, $current_date) = date_objects($year, $month, $day);

# Calculate age
($years, $months, $weeks, $days, $hours, $minutes) = date_difference_delta($start_date, $current_date);

# Get additional information
$starsign   = get_star_sign($day, $month);
$generation = get_generation($year);

# Print results page
html_head();
get_page();
html_exit();

# Collect user data safely
sub collect_data {
    my $cgi = CGI->new;
    
    # Get input values from user form
    $name  = $cgi->param("name")  || "";
    $email = $cgi->param("email") || "";
    $day   = $cgi->param("day")   || "";
    $month = $cgi->param("month") || "";
    $year  = $cgi->param("year")  || "";

    # Remove spaces and ensure values are numeric
    $day   =~ s/\D//g;
    $month =~ s/\D//g;
    $year  =~ s/\D//g;

    $dob = "$day-$month-$year";
}

# Validate email and date
sub validate_input {
    unless ($email && Email::Valid->address($email)) {
        error_page("Invalid email address! Please enter a correct email.");
    }
    unless (check_date_validity($day, $month, $year)) {
        error_page("Invalid Date of Birth! Please enter a valid date: $day-$month-$year");
    }
}

# Show error message and exit
sub error_page {
    my ($message) = @_;
    print "Content-type: text/html\n\n";
    print "<html><body><h3 style='color:red;'>Error: $message</h3></body></html>";
    exit;
}

# Check if date is valid
sub check_date_validity {
    my ($d, $m, $y) = @_;
    return 0 unless ($y && $m && $d);  # Ensure values exist
    eval { DateTime->new(year => $y, month => $m, day => $d) };
    return $@ ? 0 : 1;
}

# Create DateTime objects safely
sub date_objects {
    my ($year, $month, $day) = @_;

    my $start_date   = DateTime->new(year => $year, month => $month, day => $day);
    my $current_date = DateTime->now;

    return ($start_date, $current_date);
}

# Calculate date difference correctly
sub date_difference_delta {
    my ($start_date, $current_date) = @_;

    my $duration = $current_date->delta_days($start_date)->in_units('days');

    my $years   = int($duration / 365);
    my $remaining_days = $duration % 365;

    my $months  = int($remaining_days / 30);
    $remaining_days %= 30;

    my $weeks   = int($remaining_days / 7);
    my $days    = $remaining_days % 7;

    my $hours   = $duration * 24;
    my $minutes = $hours * 60;

    return ($years, $months, $weeks, $days, $hours, $minutes);
}

# Determine Zodiac sign
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

# Determine Generation
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

# HTML Headers
sub html_head {
    print "Content-type: text/html\n\n";
}

sub html_exit {
    exit(0);
}

# Generate Result Page
sub get_page {
    print <<__END_OF_HTML_CODE__;
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Fun Profile</title>
  <style>
    body { font-family: Arial, sans-serif; text-align: center; background: #f4f4f4; }
    .container { width: 50%; margin: auto; background: white; padding: 20px; border-radius: 10px; box-shadow: 0 4px 8px rgba(0,0,0,0.2); }
  </style>
</head>
<body>
  <div class="container">
    <h2>Fun Profile Results</h2>
    <p><strong>Name:</strong> $name</p>
    <p><strong>Email:</strong> $email</p>
    <p><strong>Date of Birth:</strong> $dob</p>
    <p><strong>Zodiac Sign:</strong> $starsign</p>
    <p><strong>Generation:</strong> $generation</p>
    <p><strong>Your Age is</p>    
    <p><strong>Years:</strong> $years</p>
    <p><strong>Months:</strong> $months</p>
    <p><strong>Weeks:</strong> $weeks</p>
    <p><strong>Days:</strong> $days</p>
    <p><strong>Hours:</strong> $hours</p>
    <p><strong>Minutes:</strong> $minutes</p>
  </div>
</body>
</html>
__END_OF_HTML_CODE__
}
