//
//  SunPositionModel.swift
//  Golden Hour
//
//  Created by Sam on 9/1/20.
//  Copyright © 2020 Sam. All rights reserved.
//

import Foundation

struct Spa_data {
    //----------------------INPUT VALUES------------------------
    
    var year: Int            // 4-digit year,      valid range: -2000 to 6000, error code: 1
    var month: Int           // 2-digit month,         valid range: 1 to  12,  error code: 2
    var day: Int             // 2-digit day,           valid range: 1 to  31,  error code: 3
    var hour: Int            // Observer local hour,   valid range: 0 to  24,  error code: 4
    var minute: Int          // Observer local minute, valid range: 0 to  59,  error code: 5
    var second: Double       // Observer local second, valid range: 0 to <60,  error code: 6
    
    var delta_ut1: Double = 0    // Fractional second difference between UTC and UT which is used
    // to adjust UTC for earth's irregular rotation rate and is derived
    // from observation only and is reported in this bulletin:
    // http://maia.usno.navy.mil/ser7/ser7.dat,
    // where delta_ut1 = DUT1
    // valid range: -1 to 1 second (exclusive), error code 17
    
    var delta_t: Double = 0      // Difference between earth rotation time and terrestrial time
    // It is derived from observation only and is reported in this
    // bulletin: http://maia.usno.navy.mil/ser7/ser7.dat,
    // where delta_t = 32.184 + (TAI-UTC) - DUT1
    // valid range: -8000 to 8000 seconds, error code: 7
    
    var timezone: Double     // Observer time zone (negative west of Greenwich)
    // valid range: -18   to   18 hours,   error code: 8
    
    var longitude: Double    // Observer longitude (negative west of Greenwich)
    // valid range: -180  to  180 degrees, error code: 9
    
    var latitude: Double     // Observer latitude (negative south of equator)
    // valid range: -90   to   90 degrees, error code: 10
    
    var elevation: Double = 300   // Observer elevation [meters]
    // valid range: -6500000 or higher meters,    error code: 11
    
    var pressure: Double = 1013.25 //Sea level   // Annual average local pressure [millibars]
    // valid range:    0 to 5000 millibars,       error code: 12
    
    var temperature: Double = 15 // Annual average local temperature [degrees Celsius]
    // valid range: -273 to 6000 degrees Celsius, error code; 13
    
    var slope: Double = 0     // Surface slope (measured from the horizontal plane)
    // valid range: -360 to 360 degrees, error code: 14
    
    var azm_rotation: Double = 0 // Surface azimuth rotation (measured from south to projection of
    //     surface normal on horizontal plane, negative east)
    // valid range: -360 to 360 degrees, error code: 15
    
    var atmos_refract: Double = 0.5667 // Atmospheric refraction at sunrise and sunset (0.5667 deg is typical)
    // valid range: -5   to   5 degrees, error code: 16
    
    var function: Int = 1        // Switch to choose functions for desired output (from enumeration)
//    A list of function
//    SPA_ZA = 0,           //calculate zenith and azimuth
//    SPA_ZA_INC = 1,      //calculate zenith, azimuth, and incidence
//    SPA_ZA_RTS = 2,      //calculate zenith, azimuth, and sun rise/transit/set values
//    SPA_ALL = 3         //calculate all SPA output values
    
    //-----------------Intermediate OUTPUT VALUES--------------------
    
    var jd: Double = 0          //Julian day
    var jc: Double = 0          //Julian century
    
    var jde: Double = 0         //Julian ephemeris day
    var jce: Double = 0         //Julian ephemeris century
    var jme: Double = 0         //Julian ephemeris millennium
    
    var l: Double = 0           //earth heliocentric longitude [degrees]
    var b: Double = 0           //earth heliocentric latitude [degrees]
    var r: Double = 0           //earth radius vector [Astronomical Units, AU]
    
    var theta: Double = 0       //geocentric longitude [degrees]
    var beta: Double = 0        //geocentric latitude [degrees]
    
    var x0: Double = 0          //mean elongation (moon-sun) [degrees]
    var x1: Double = 0          //mean anomaly (sun) [degrees]
    var x2: Double = 0          //mean anomaly (moon) [degrees]
    var x3: Double = 0          //argument latitude (moon) [degrees]
    var x4: Double = 0          //ascending longitude (moon) [degrees]
    
    var del_psi: Double = 0     //nutation longitude [degrees]
    var del_epsilon: Double = 0 //nutation obliquity [degrees]
    var epsilon0: Double = 0    //ecliptic mean obliquity [arc seconds]
    var epsilon: Double = 0     //ecliptic true obliquity  [degrees]
    
    var del_tau: Double = 0     //aberration correction [degrees]
    var lamda: Double = 0       //apparent sun longitude [degrees]
    var nu0: Double = 0        //Greenwich mean sidereal time [degrees]
    var nu: Double = 0          //Greenwich sidereal time [degrees]
    
    var alpha: Double = 0       //geocentric sun right ascension [degrees]
    var delta: Double = 0       //geocentric sun declination [degrees]
    
    var h: Double = 0           //observer hour angle [degrees]
    var xi: Double = 0          //sun equatorial horizontal parallax [degrees]
    var del_alpha: Double = 0   //sun right ascension parallax [degrees]
    var delta_prime: Double = 0 //topocentric sun declination [degrees]
    var alpha_prime: Double = 0 //topocentric sun right ascension [degrees]
    var h_prime: Double = 0     //topocentric local hour angle [degrees]
    
    var e0: Double = 0          //topocentric elevation angle (uncorrected) [degrees]
    var del_e: Double = 0       //atmospheric refraction correction [degrees]
    var e: Double = 0           //topocentric elevation angle (corrected) [degrees]
    
    var eot: Double = 0         //equation of time [minutes]
    var srha: Double = 0        //sunrise hour angle [degrees]
    var ssha: Double = 0        //sunset hour angle [degrees]
    var sta: Double = 0         //sun transit altitude [degrees]
    
    //---------------------Final OUTPUT VALUES------------------------
    
    var zenith: Double = 0      //topocentric zenith angle [degrees]
    var azimuth_astro: Double = 0 //topocentric azimuth angle (westward from south) [for astronomers]
    var azimuth: Double = 0      //topocentric azimuth angle (eastward from north) [for navigators and solar radiation]
    var incidence: Double = 0    //surface incidence angle [degrees]
    var declination: Double = 0  // [degrees]
    
    var suntransit: Double = 0   //local sun transit time (or solar noon) [fractional hour]
    var sunrise: Double = 0      //local sunrise time (+/- 30 seconds) [fractional hour]
    var sunset: Double = 0       //local sunset time (+/- 30 seconds) [fractional hour]
    
    init(_ date: Date, _ timezone: Double, longitude: Double, latitude: Double)
    {
        let calendar = Calendar.current
        self.year = calendar.component(.year, from: date)
        self.month = calendar.component(.month, from: date)
        self.day = calendar.component(.day, from: date)
        self.hour = calendar.component(.hour, from: date)
        self.minute = calendar.component(.minute, from: date)
        self.second = Double(calendar.component(.second, from: date))
        self.timezone = timezone
        self.longitude = longitude
        self.latitude = latitude
        print("\(year)-\(month)-\(day), \(hour):\(minute):\(second) GMT\(timezone)")
    }
}


func rad2deg(_ radians: Double) -> Double {
    return (180.0/PI)*radians
}

func deg2rad(_ degrees: Double) -> Double {
    return (PI/180.0)*degrees
}

func integer(_ value: Double) -> Int {
    return Int(value)
}

func limit_degrees(_ degrees: Double) -> Double {
    let tempDegrees = degrees / 360.0
    var limited: Double = 360.0 * ( tempDegrees - floor(tempDegrees))
    
    if (limited < 0) { limited += 360.0 }
    return limited
}

func limit_degrees180pm(_ degrees: Double) -> Double {
    let tempDegrees = degrees / 360.0
    var limited = 360.0*(tempDegrees-floor(tempDegrees))
    if      (limited < -180.0) { limited += 360.0 }
    else if (limited >  180.0) { limited -= 360.0 }
    
    return limited
}

func limit_degrees180(_ degrees: Double) -> Double {
    let tempDegrees = degrees / 180.0
    var limited = 180.0*(tempDegrees-floor(tempDegrees))
    if (limited < 0) { limited += 180.0 }
    
    return limited
}

func limit_zero2one(_ value: Double) -> Double {
    var limited = value - floor(value)
    if (limited < 0) { limited += 1.0 }
    
    return limited
}

func limit_minutes(_ minutes: Double) -> Double {
    var limited = minutes
    
    if      (limited < -20.0) { limited += 1440.0 }
    else if (limited >  20.0) { limited -= 1440.0 }
    
    return limited
}

func dayfrac_to_local_hr(_ dayfrac: Double, _ timezone: Double) -> Double
{
    return 24.0 * limit_zero2one(dayfrac + timezone/24.0)
}

func third_order_polynomial(_ a: Double, _ b: Double, _ c: Double, _ d: Double, _ x: Double) -> Double
{
    return ((a*x + b)*x + c)*x + d
}

///////////////////////////////////////////////////////////////////////////////////////////////
func validate_inputs(spa: inout Spa_data) -> Int
{
    if ((spa.year        < -2000) || (spa.year        > 6000)) { return 1 }
    if ((spa.month       < 1    ) || (spa.month       > 12  )) { return 2 }
    if ((spa.day         < 1    ) || (spa.day         > 31  )) { return 3 }
    if ((spa.hour        < 0    ) || (spa.hour        > 24  )) { return 4 }
    if ((spa.minute      < 0    ) || (spa.minute      > 59  )) { return 5 }
    if ((spa.second      < 0    ) || (spa.second      >=  60  )) { return 6 }
    if ((spa.pressure    < 0    ) || (spa.pressure    > 5000)) { return 12 }
    if ((spa.temperature <= -273) || (spa.temperature > 6000)) { return 13 }
    if ((spa.delta_ut1   <= -1  ) || (spa.delta_ut1   >= 1  )) { return 17 }
    if ((spa.hour        == 24  ) && (spa.minute      > 0   )) { return 5 }
    if ((spa.hour        == 24  ) && (spa.second      > 0   )) { return 6 }
    
    if (fabs(spa.delta_t)       > 8000    ) { return 7 }
    if (fabs(spa.timezone)      > 18      ) { return 8 }
    if (fabs(spa.longitude)     > 180     ) { return 9 }
    if (fabs(spa.latitude)      > 90      ) { return 10 }
    if (fabs(spa.atmos_refract) > 5       ) { return 16 }
    if (     spa.elevation      < -6500000) { return 11 }
    
    if ((spa.function == SPA_ZA_INC) || (spa.function == SPA_ALL))
    {
        if (fabs(spa.slope)         > 360) { return 14 }
        if (fabs(spa.azm_rotation)  > 360) { return 15 }
    }
    
    return 0
}
///////////////////////////////////////////////////////////////////////////////////////////////
func julian_day (_ year: Int, _ month: Int, _ day: Int, _ hour: Int, _ minute: Int, _ second: Double, _ dut1: Double, _ tz: Double) -> Double
{
    var year_temp = year
    var month_temp = month
    let temp = Double(minute) + ((second + dut1) / 60.0)
    let temp2 = (Double(hour) - tz + temp / 60.0) / 24.0
    let day_decimal = Double(day) + temp2
    
    if ( month < 3 )
    {
        month_temp += 12
        year_temp -= 1
    }
    
    let julian_day_temp1: Int = Int(365.25 * (Double(year_temp) + 4716.0))
    let julian_day_temp2: Int = Int(30.6001 * Double((month_temp + 1)))
    var julian_day_temp = Double(julian_day_temp1) + Double(julian_day_temp2) + day_decimal - 1524.5
    
    if (julian_day_temp > 2299160.0) {
        let a_temp = Int(year_temp/100)
        julian_day_temp += Double((2 - a_temp + Int(a_temp/4)))
    }
    
    return julian_day_temp
}

func julian_century(_ jd: Double) -> Double
{
    return (jd-2451545.0)/36525.0
}

func julian_ephemeris_day(_ jd: Double, _ delta_t: Double) -> Double
{
    return jd+delta_t/86400.0
}

func julian_ephemeris_century(_ jde: Double) -> Double
{
    return (jde - 2451545.0)/36525.0
}

func julian_ephemeris_millennium(_ jce: Double) -> Double
{
    return (jce/10.0)
}

func earth_periodic_term_summation( terms: [[Double]], count: Int, jme: Double) -> Double
{
    var sum: Double = 0
    
    for i in 0..<count
    {
        sum += terms[i][TERM_A] * cos(terms[i][TERM_B] + terms[i][TERM_C] * jme)
    }
    
    return sum
}

func earth_values(term_sum: [Double], count: Int, jme: Double) -> Double
{
    var sum: Double = 0
    
    for i in 0 ..< count
    {    sum += term_sum[i] * pow(jme, Double(i)) }
    
    sum /= 1.0e8
    
    return sum
}

func earth_heliocentric_longitude(_ jme: Double) -> Double
{
    var sum: [Double] = []
    
    for i in 0 ..< L_COUNT
    {
        sum.append( earth_periodic_term_summation(terms: L_TERMS[i], count: l_subcount[i], jme: jme) )
    }
    return limit_degrees(rad2deg(earth_values(term_sum: sum, count: L_COUNT, jme: jme)))
}

func earth_heliocentric_latitude(_ jme: Double) -> Double
{
    var sum: [Double] = []
    for i in 0 ..< B_COUNT
    {
        sum.append( earth_periodic_term_summation(terms: B_TERMS[i], count: b_subcount[i], jme: jme) )
    }
    
    return rad2deg(earth_values(term_sum: sum, count: B_COUNT, jme: jme))
}

func earth_radius_vector(_ jme: Double) -> Double
{
    var sum:[Double] = []
    
    for i in 0 ..< R_COUNT
    {
        sum.append( earth_periodic_term_summation(terms: R_TERMS[i], count: r_subcount[i], jme: jme) )
    }
    
    return earth_values(term_sum: sum, count: R_COUNT, jme: jme)
}

func geocentric_longitude(_ l: Double) -> Double
{
    var theta: Double = l + 180.0
    
    if (theta >= 360.0) {theta -= 360.0}
    
    return theta
}

func geocentric_latitude(_ b: Double) -> Double
{
    return -b
}

func mean_elongation_moon_sun(_ jce: Double) -> Double
{
    return third_order_polynomial(1.0/189474.0, -0.0019142, 445267.11148, 297.85036, jce)
}

func mean_anomaly_sun(_ jce: Double) -> Double
{
    return third_order_polynomial(-1.0/300000.0, -0.0001603, 35999.05034, 357.52772, jce)
}

func mean_anomaly_moon(_ jce:Double) -> Double
{
    return third_order_polynomial(1.0/56250.0, 0.0086972, 477198.867398, 134.96298, jce)
}

func argument_latitude_moon(_ jce: Double) -> Double
{
    return third_order_polynomial(1.0/327270.0, -0.0036825, 483202.017538, 93.27191, jce)
}

func ascending_longitude_moon(_ jce: Double) -> Double
{
    return third_order_polynomial(1.0/450000.0, 0.0020708, -1934.136261, 125.04452, jce)
}

func xy_term_summation( i: Int, x: [Double]) -> Double
{
    var sum: Double = 0
    
    for j in 0 ..< TERM_Y_COUNT
    {
        sum += x[j] * Double(Y_TERMS[i][j])
    }
    
    return sum
}

func nutation_longitude_and_obliquity(_ jce: Double, _ x: [Double], _ del_psi: inout Double, _ del_epsilon: inout Double)
{
    var xy_term_sum: Double, sum_psi: Double = 0, sum_epsilon: Double = 0
    
    for i in 0 ..< Y_COUNT
    {
        xy_term_sum  = deg2rad(xy_term_summation(i:i, x:x))
        sum_psi     += (PE_TERMS[i][TERM_PSI_A] + jce*PE_TERMS[i][TERM_PSI_B])*sin(xy_term_sum)
        sum_epsilon += (PE_TERMS[i][TERM_EPS_C] + jce*PE_TERMS[i][TERM_EPS_D])*cos(xy_term_sum)
    }
    
    del_psi     = sum_psi     / 36000000.0
    del_epsilon = sum_epsilon / 36000000.0
}

func ecliptic_mean_obliquity(_ jme: Double) -> Double
{
    let u: Double = jme/10.0
    
    return 84381.448 + u*(-4680.93 + u*(-1.55 + u*(1999.25 + u*(-51.38 + u*(-249.67 +
        u*(  -39.05 + u*( 7.12 + u*(  27.87 + u*(  5.79 + u*2.45)))))))))
}

func ecliptic_true_obliquity(_ delta_epsilon: Double, _ epsilon0: Double) -> Double
{
    return delta_epsilon + epsilon0/3600.0;
}

func aberration_correction(_ r: Double) -> Double
{
    return -20.4898 / (3600.0*r)
}

func apparent_sun_longitude(_ theta: Double, _ delta_psi: Double, _ delta_tau: Double) -> Double
{
    return theta + delta_psi + delta_tau
}

func greenwich_mean_sidereal_time (_ jd: Double, _ jc: Double) -> Double
{
    return limit_degrees(280.46061837 + 360.98564736629 * (jd - 2451545.0) +
        jc*jc*(0.000387933 - jc/38710000.0))
}

func greenwich_sidereal_time (_ nu0: Double, _ delta_psi: Double, _ epsilon: Double) -> Double
{
    return nu0 + delta_psi * cos(deg2rad(epsilon))
}

func geocentric_right_ascension(_ lamda: Double, _ epsilon: Double, _ beta: Double) -> Double
{
    let lamda_rad: Double = deg2rad(lamda)
    let epsilon_rad: Double = deg2rad(epsilon)
    
    return limit_degrees(rad2deg(atan2(sin(lamda_rad)*cos(epsilon_rad) -
        tan(deg2rad(beta))*sin(epsilon_rad), cos(lamda_rad))))
}

func geocentric_declination(_ beta: Double, _ epsilon: Double, _ lamda: Double) -> Double
{
    let beta_rad: Double = deg2rad(beta)
    let epsilon_rad: Double = deg2rad(epsilon)
    
    return rad2deg(asin(sin(beta_rad)*cos(epsilon_rad) +
        cos(beta_rad)*sin(epsilon_rad)*sin(deg2rad(lamda))))
}

func observer_hour_angle(_ nu: Double, _ longitude: Double, _ alpha_deg: Double) -> Double
{
    return limit_degrees(nu + longitude - alpha_deg)
}

func sun_equatorial_horizontal_parallax(r: Double) -> Double
{
    return 8.794 / (3600.0 * r)
}

func right_ascension_parallax_and_topocentric_dec(_ latitude: Double, _ elevation: Double,_ xi: Double,_ h: Double,_ delta: Double,_ delta_alpha: inout Double,_ delta_prime: inout Double)
{
    let lat_rad: Double   = deg2rad(latitude)
    let xi_rad: Double    = deg2rad(xi)
    let h_rad: Double     = deg2rad(h)
    let delta_rad: Double = deg2rad(delta)
    let u: Double = atan(0.99664719 * tan(lat_rad))
    let y: Double = 0.99664719 * sin(u) + elevation*sin(lat_rad)/6378140.0
    let x: Double =              cos(u) + elevation*cos(lat_rad)/6378140.0
    
    let delta_alpha_rad: Double = atan2( -(x * sin(xi_rad) * sin(h_rad)), cos(delta_rad) - x * sin(xi_rad) * cos(h_rad))
    delta_prime = rad2deg(atan2((sin(delta_rad) - y*sin(xi_rad))*cos(delta_alpha_rad),cos(delta_rad) - x*sin(xi_rad) * cos(h_rad)))
    delta_alpha = rad2deg(delta_alpha_rad)
}

func topocentric_right_ascension(_ alpha_deg: Double,_ delta_alpha: Double) -> Double
{
    return alpha_deg + delta_alpha
}

func topocentric_local_hour_angle(_ h: Double, _ delta_alpha: Double) -> Double
{
    return h - delta_alpha
}

func topocentric_elevation_angle(_ latitude: Double,_ delta_prime: Double,_ h_prime: Double) -> Double
{
    let lat_rad: Double         = deg2rad(latitude)
    let delta_prime_rad: Double = deg2rad(delta_prime)
    
    return rad2deg(asin(sin(lat_rad)*sin(delta_prime_rad) + cos(lat_rad)*cos(delta_prime_rad) * cos(deg2rad(h_prime))))
}

func atmospheric_refraction_correction(_ pressure: Double,_ temperature: Double,_ atmos_refract: Double,_ e0: Double) -> Double
{
    var del_e: Double = 0
    
    if ( e0 >= ( -1 * (SUN_RADIUS + atmos_refract)) )
    {
        del_e = (pressure / 1010.0) * (283.0 / (273.0 + temperature)) * 1.02 / (60.0 * tan(deg2rad(e0 + 10.3/(e0 + 5.11))))
    }
    return del_e
}

func topocentric_elevation_angle_corrected(_ e0: Double,_ delta_e: Double) -> Double
{
    return e0 + delta_e
}

func topocentric_zenith_angle(_ e: Double) -> Double
{
    return 90.0 - e
}

func topocentric_azimuth_angle_astro(_ h_prime: Double, _ latitude: Double, _ delta_prime: Double) -> Double
{
    let h_prime_rad: Double = deg2rad(h_prime)
    let lat_rad: Double = deg2rad(latitude)
    
    return limit_degrees(rad2deg(atan2(sin(h_prime_rad), cos(h_prime_rad)*sin(lat_rad) - tan(deg2rad(delta_prime))*cos(lat_rad))))
}

func topocentric_azimuth_angle(_ azimuth_astro: Double) -> Double
{
    return limit_degrees(azimuth_astro + 180.0)
}

func surface_incidence_angle(_ zenith: Double, _ azimuth_astro: Double,_ azm_rotation: Double,_ slope: Double) -> Double
{
    let zenith_rad: Double = deg2rad(zenith)
    let slope_rad: Double = deg2rad(slope)
    
    return rad2deg(acos(cos(zenith_rad)*cos(slope_rad) + sin(slope_rad) * sin(zenith_rad) * cos(deg2rad(azimuth_astro - azm_rotation))))
}

func sun_mean_longitude(_ jme: Double) -> Double
{
    return limit_degrees(280.4664567 + jme*(360007.6982779 + jme*(0.03032028 + jme*(1/49931.0   + jme*(-1/15300.0     + jme*(-1/2000000.0))))))
}

func eot(_ m: Double, _ alpha: Double, _ del_psi: Double, _ epsilon: Double) -> Double
{
    return limit_minutes(4.0*(m - 0.0057183 - alpha + del_psi*cos(deg2rad(epsilon))))
}

func approx_sun_transit_time(_ alpha_zero: Double,_ longitude: Double,_ nu: Double) -> Double
{
    return (alpha_zero - longitude - nu) / 360.0
}

func sun_hour_angle_at_rise_set(_ latitude: Double, _ delta_zero: Double,_ h0_prime: Double) -> Double
{
    var h0: Double             = -99999
    let latitude_rad: Double   = deg2rad(latitude)
    let delta_zero_rad: Double = deg2rad(delta_zero)
    let argument: Double = (sin(deg2rad(h0_prime)) - sin(latitude_rad) * sin(delta_zero_rad)) / (cos(latitude_rad) * cos(delta_zero_rad))
    
    if (fabs(argument) <= 1) { h0 = limit_degrees180(rad2deg(acos(argument))) }
    
    return h0
}

func approx_sun_rise_and_set(_ m_rts: inout [Double], h0: Double)
{
    let h0_dfrac: Double = h0/360.0
    
    m_rts[SUN_RISE]    = limit_zero2one(m_rts[SUN_TRANSIT] - h0_dfrac)
    m_rts[SUN_SET]     = limit_zero2one(m_rts[SUN_TRANSIT] + h0_dfrac)
    m_rts[SUN_TRANSIT] = limit_zero2one(m_rts[SUN_TRANSIT])
}

func rts_alpha_delta_prime(ad: inout [Double], n: Double) -> Double
{
    var a: Double = ad[JD_ZERO] - ad[JD_MINUS]
    var b: Double = ad[JD_PLUS] - ad[JD_ZERO]
    
    if (fabs(a) >= 2.0) { a = limit_zero2one(a) }
    if (fabs(b) >= 2.0) { b = limit_zero2one(b) }
    
    return ad[JD_ZERO] + n * (a + b + (b-a) * n) / 2.0
}

func rts_sun_altitude(_ latitude: Double, _ delta_prime: Double, _ h_prime: Double) -> Double
{
    let latitude_rad: Double    = deg2rad(latitude)
    let delta_prime_rad: Double = deg2rad(delta_prime)
    
    return rad2deg(asin(sin(latitude_rad)*sin(delta_prime_rad) + cos(latitude_rad)*cos(delta_prime_rad)*cos(deg2rad(h_prime))))
}

func sun_rise_and_set(_ m_rts: inout [Double],_ h_rts: inout [Double],_ delta_prime: inout [Double], _ latitude: Double, _ h_prime: inout [Double],_ h0_prime: Double,_ sun: Int) -> Double
{
    return m_rts[sun] + (h_rts[sun] - h0_prime) / (360.0 * cos(deg2rad(delta_prime[sun])) * cos(deg2rad(latitude)) * sin(deg2rad(h_prime[sun])))
}

////////////////////////////////////////////////////////////////////////////////////////////////
// Calculate required SPA parameters to get the right ascension (alpha) and declination (delta)
// Note: JD must be already calculated and in structure
////////////////////////////////////////////////////////////////////////////////////////////////
func calculate_geocentric_sun_right_ascension_and_declination(spa: inout Spa_data)
{
    var x:[Double] = [] //double x[TERM_X_COUNT]
    
    spa.jc = julian_century(spa.jd)
    
    spa.jde = julian_ephemeris_day(spa.jd, spa.delta_t)
    spa.jce = julian_ephemeris_century(spa.jde)
    spa.jme = julian_ephemeris_millennium(spa.jce)
    
    spa.l = earth_heliocentric_longitude(spa.jme)
    spa.b = earth_heliocentric_latitude(spa.jme)
    spa.r = earth_radius_vector(spa.jme)
    
    spa.theta = geocentric_longitude(spa.l)
    spa.beta  = geocentric_latitude(spa.b)
    
    spa.x0 = mean_elongation_moon_sun(spa.jce)
    spa.x1 = mean_anomaly_sun(spa.jce)
    spa.x2 = mean_anomaly_moon(spa.jce)
    spa.x3 = argument_latitude_moon(spa.jce)
    spa.x4 = ascending_longitude_moon(spa.jce)
    
    x.append( spa.x0 )
    x.append( spa.x1 )
    x.append( spa.x2 )
    x.append( spa.x3 )
    x.append( spa.x4 )
    
    
    nutation_longitude_and_obliquity(spa.jce, x, &spa.del_psi, &spa.del_epsilon)
    
    spa.epsilon0 = ecliptic_mean_obliquity(spa.jme)
    spa.epsilon  = ecliptic_true_obliquity(spa.del_epsilon, spa.epsilon0)
    
    spa.del_tau   = aberration_correction(spa.r)
    spa.lamda     = apparent_sun_longitude(spa.theta, spa.del_psi, spa.del_tau)
    spa.nu0       = greenwich_mean_sidereal_time (spa.jd, spa.jc)
    spa.nu        = greenwich_sidereal_time (spa.nu0, spa.del_psi, spa.epsilon)
    
    spa.alpha = geocentric_right_ascension(spa.lamda, spa.epsilon, spa.beta)
    spa.delta = geocentric_declination(spa.beta, spa.epsilon, spa.lamda)
}

////////////////////////////////////////////////////////////////////////
// Calculate Equation of Time (EOT) and Sun Rise, Transit, & Set (RTS)
////////////////////////////////////////////////////////////////////////

func calculate_eot_and_sun_rise_transit_set(spa: inout Spa_data)
{
    var sun_rts: Spa_data
    var alpha: [Double] = [], delta: [Double] = []
        //double alpha[JD_COUNT], delta[JD_COUNT]
    var m_rts: [Double] = [], nu_rts: [Double] = [], h_rts: [Double] = []
        //double m_rts[SUN_COUNT], nu_rts[SUN_COUNT], h_rts[SUN_COUNT];
    var alpha_prime: [Double] = [], delta_prime: [Double] = [], h_prime: [Double] = []
        //double alpha_prime[SUN_COUNT], delta_prime[SUN_COUNT], h_prime[SUN_COUNT]
    let h0_prime: Double = -1 * (SUN_RADIUS + spa.atmos_refract)
    
    sun_rts  = spa  //sun_rts  = *spa
    let m = sun_mean_longitude(spa.jme)
    spa.eot = eot(m, spa.alpha, spa.del_psi, spa.epsilon)
    
    sun_rts.hour = 0
    sun_rts.minute = 0
    sun_rts.second = 0
    sun_rts.delta_ut1 = 0.0
    sun_rts.timezone = 0.0
    
    sun_rts.jd = julian_day (sun_rts.year, sun_rts.month, sun_rts.day, sun_rts.hour, sun_rts.minute, sun_rts.second, sun_rts.delta_ut1, sun_rts.timezone)
    
    calculate_geocentric_sun_right_ascension_and_declination(spa: &sun_rts)
    let nu = sun_rts.nu
    
    sun_rts.delta_t = 0
    sun_rts.jd -= 1
    for i in 0 ..< JD_COUNT
    {
        calculate_geocentric_sun_right_ascension_and_declination(spa: &sun_rts)
        alpha[i] = sun_rts.alpha
        delta[i] = sun_rts.delta
        sun_rts.jd += 1
    }
    
    m_rts[SUN_TRANSIT] = approx_sun_transit_time(alpha[JD_ZERO], spa.longitude, nu)
    let h0 = sun_hour_angle_at_rise_set(spa.latitude, delta[JD_ZERO], h0_prime)
    
    if (h0 >= 0) {
        
        approx_sun_rise_and_set(&m_rts, h0: h0)
        
        for i in 0 ..< SUN_COUNT
        {
            nu_rts[i]      = nu + 360.985647 * m_rts[i]
            
            let n              = m_rts[i] + spa.delta_t / 86400.0
            alpha_prime[i] = rts_alpha_delta_prime(ad: &alpha, n: n)
            delta_prime[i] = rts_alpha_delta_prime(ad: &delta, n: n)
            
            h_prime[i]     = limit_degrees180pm(nu_rts[i] + spa.longitude - alpha_prime[i])
            
            h_rts[i]       = rts_sun_altitude(spa.latitude, delta_prime[i], h_prime[i])
        }
        
        spa.srha = h_prime[SUN_RISE]
        spa.ssha = h_prime[SUN_SET]
        spa.sta  = h_rts[SUN_TRANSIT]
        
        spa.suntransit = dayfrac_to_local_hr(m_rts[SUN_TRANSIT] - h_prime[SUN_TRANSIT] / 360.0, spa.timezone)
        
        spa.sunrise = dayfrac_to_local_hr( sun_rise_and_set(&m_rts, &h_rts, &delta_prime, spa.latitude, &h_prime, h0_prime, SUN_RISE), spa.timezone)
        
        spa.sunset  = dayfrac_to_local_hr(sun_rise_and_set(&m_rts, &h_rts, &delta_prime, spa.latitude, &h_prime, h0_prime, SUN_SET),  spa.timezone)
        
    } else
    {
        spa.srha = -99999
        spa.ssha = -99999
        spa.sta = -99999
        spa.suntransit = -99999
        spa.sunrise = -99999
        spa.sunset = -99999
    }
    
}

///////////////////////////////////////////////////////////////////////////////////////////
// Calculate all SPA parameters and put into structure
// Note: All inputs values (listed in header file) must already be in structure
///////////////////////////////////////////////////////////////////////////////////////////
func spa_calculate(spa: inout Spa_data) -> Int
{
    let result: Int = validate_inputs(spa: &spa)
    
    if (result == 0)
    {
        spa.jd = julian_day (spa.year, spa.month, spa.day, spa.hour, spa.minute, spa.second, spa.delta_ut1, spa.timezone)
        
        calculate_geocentric_sun_right_ascension_and_declination(spa: &spa)
        
        spa.h  = observer_hour_angle(spa.nu, spa.longitude, spa.alpha)
        spa.xi = sun_equatorial_horizontal_parallax(r: spa.r)
        
        right_ascension_parallax_and_topocentric_dec(spa.latitude, spa.elevation, spa.xi, spa.h, spa.delta, &spa.del_alpha, &spa.delta_prime)
        
        spa.alpha_prime = topocentric_right_ascension(spa.alpha, spa.del_alpha)
        spa.h_prime     = topocentric_local_hour_angle(spa.h, spa.del_alpha)
        
        spa.e0      = topocentric_elevation_angle(spa.latitude, spa.delta_prime, spa.h_prime)
        spa.del_e   = atmospheric_refraction_correction(spa.pressure, spa.temperature,
                                                        spa.atmos_refract, spa.e0)
        spa.e       = topocentric_elevation_angle_corrected(spa.e0, spa.del_e)
        
        spa.zenith        = topocentric_zenith_angle(spa.e)
        spa.azimuth_astro = topocentric_azimuth_angle_astro(spa.h_prime, spa.latitude,spa.delta_prime)
        spa.azimuth       = topocentric_azimuth_angle(spa.azimuth_astro)
        
        if ((spa.function == SPA_ZA_INC) || (spa.function == SPA_ALL))
        {
            spa.incidence  = surface_incidence_angle(spa.zenith, spa.azimuth_astro, spa.azm_rotation, spa.slope)
            spa.declination = 90 - spa.incidence
        }
        
        if ((spa.function == SPA_ZA_RTS) || (spa.function == SPA_ALL))
        {
            calculate_eot_and_sun_rise_transit_set(spa: &spa)
        }
    }
    
    return result
}
///////////////////////////////////////////////////////////////////////////////////////////
