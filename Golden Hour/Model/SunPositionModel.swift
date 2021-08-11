import Foundation

struct SunPositionModel {
    //----------------------INPUT VALUES------------------------
    
    var date: Date
    var year: Int = 0           // 4-digit year,      valid range: -2000 to 6000, error code: 1
    var month: Int = 0          // 2-digit month,         valid range: 1 to  12,  error code: 2
    var day: Int = 0            // 2-digit day,           valid range: 1 to  31,  error code: 3
    var hour: Int = 0           // Observer local hour,   valid range: 0 to  24,  error code: 4
    var minute: Int = 0         // Observer local minute, valid range: 0 to  59,  error code: 5
    var second: Double = 0      // Observer local second, valid range: 0 to <60,  error code: 6
    
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
    
    init(_ date: Date, _ GMT: Double, longitude: Double, latitude: Double)
    {
        self.date = date
        self.timezone = GMT
        self.longitude = longitude
        self.latitude = latitude
    }
    
    mutating func setDate(_ newDate: Date)
    {
        self.date = newDate
    }
    
    mutating func parseDate()
    {
        // + fix apply timezone on calendar
        let calendar = Calendar.current
        self.year = calendar.component(.year, from: self.date)
        self.month = calendar.component(.month, from: self.date)
        self.day = calendar.component(.day, from: self.date)
        self.hour = calendar.component(.hour, from: self.date)
        self.minute = calendar.component(.minute, from: self.date)
        self.second = Double(calendar.component(.second, from: self.date))
        print("\(year)-\(month)-\(day), \(hour):\(minute):\(second) GMT\(timezone)")
    }
    
    func rad2deg(_ radians: Double) -> Double {
        return (180.0 / PI) * radians
    }
    
    func deg2rad(_ degrees: Double) -> Double {
        return (PI / 180.0) * degrees
    }
    
    func limit_degrees(_ degrees: Double) -> Double {
        let tempDegrees = degrees / 360.0
        var limited: Double = 360.0 * ( tempDegrees - round(tempDegrees))
        
        if (limited < 0) { limited += 360.0 }
        return limited
    }
    
    func limit_degrees180pm(_ degrees: Double) -> Double {
        let tempDegrees = degrees / 360.0
        var limited = 360.0 * ( tempDegrees - round(tempDegrees) )
        if      (limited < -180.0) { limited += 360.0 }
        else if (limited >  180.0) { limited -= 360.0 }
        
        return limited
    }
    
    func limit_degrees180(_ degrees: Double) -> Double {
        let tempDegrees = degrees / 180.0
        var limited = 180.0 * ( tempDegrees - round(tempDegrees) )
        if (limited < 0) { limited += 180.0 }
        
        return limited
    }
    
    func limit_zero2one(_ value: Double) -> Double {
        var limited = value - round(value)
        if (limited < 0) { limited += 1.0 }
        
        return limited
    }
    
    func limit_minutes(_ minutes: Double) -> Double {
        var limited = minutes
        if      (limited < -20.0) { limited += 1440.0 }
        else if (limited >  20.0) { limited -= 1440.0 }
        
        return limited
    }
    
    func dayfrac_to_local_hr(_ dayfrac: Double) -> Double
    {
        return 24.0 * limit_zero2one(dayfrac + self.timezone / 24.0)
    }
    
    func third_order_polynomial(_ a: Double, _ b: Double, _ c: Double, _ d: Double, _ x: Double) -> Double
    {
        return ( ( a * x + b ) * x + c) * x + d
    }
    
    // ------------------------------------------------------------------
    func validate_inputs() -> Int
    {
        if ((self.year        < -2000) || (self.year        > 6000)) { return 1 }
        if ((self.month       < 1    ) || (self.month       > 12  )) { return 2 }
        if ((self.day         < 1    ) || (self.day         > 31  )) { return 3 }
        if ((self.hour        < 0    ) || (self.hour        > 24  )) { return 4 }
        if ((self.minute      < 0    ) || (self.minute      > 59  )) { return 5 }
        if ((self.second      < 0    ) || (self.second      >=  60  )) { return 6 }
        if ((self.pressure    < 0    ) || (self.pressure    > 5000)) { return 12 }
        if ((self.temperature <= -273) || (self.temperature > 6000)) { return 13 }
        if ((self.delta_ut1   <= -1  ) || (self.delta_ut1   >= 1  )) { return 17 }
        if ((self.hour        == 24  ) && (self.minute      > 0   )) { return 5 }
        if ((self.hour        == 24  ) && (self.second      > 0   )) { return 6 }
        
        if (fabs(self.delta_t)       > 8000    ) { return 7 }
        if (fabs(self.timezone)      > 18      ) { return 8 }
        if (fabs(self.longitude)     > 180     ) { return 9 }
        if (fabs(self.latitude)      > 90      ) { return 10 }
        if (fabs(self.atmos_refract) > 5       ) { return 16 }
        if (     self.elevation      < -6500000) { return 11 }
        
//        if ((self.function == SPA_ZA_INC) || (self.function == SPA_ALL))
//        {
//            if (fabs(self.slope)         > 360) { return 14 }
//            if (fabs(self.azm_rotation)  > 360) { return 15 }
//        }
        
        return 0
    }
    
    // ---------------------------------------------------------------------
    func julian_day() -> Double
    {
        var year_temp = self.year
        var month_temp = self.month
        let temp = Double(self.minute) + ((self.second + self.delta_ut1) / 60.0)
        let temp2 = (Double(self.hour) - self.timezone + temp / 60.0) / 24.0
        let day_decimal = Double(self.day) + temp2
        
        if ( month_temp < 3 )
        {
            month_temp += 12
            year_temp -= 1
        }
        
        let julian_day_temp1: Int = Int(365.25 * (Double(year_temp) + 4716.0))
        let julian_day_temp2: Int = Int(30.6001 * Double((month_temp + 1)))
        var julian_day_result = Double(julian_day_temp1) + Double(julian_day_temp2) + day_decimal - 1524.5
        
        if (julian_day_result > 2299160.0) {
            let a_temp = Int(year_temp/100)
            julian_day_result += Double((2 - a_temp + Int(a_temp/4)))
        }
        
        return julian_day_result
    }
    
    func julian_century() -> Double
    {
        return ( self.jd - 2451545.0 ) / 36525.0
    }
    
    func julian_ephemeris_day() -> Double
    {
        return self.jd + self.delta_t / 86400.0
    }
    
    func julian_ephemeris_century() -> Double
    {
        return (self.jde - 2451545.0)/36525.0
    }
    
    func julian_ephemeris_millennium() -> Double
    {
        return (self.jce / 10.0)
    }
    
    func earth_periodic_term_summation( terms: [[Double]], count: Int) -> Double
    {
        var sum: Double = 0
        
        for i in 0..<count
        {
            sum += terms[i][TERM_A] * cos(terms[i][TERM_B] + terms[i][TERM_C] * self.jme)
        }
        
        return sum
    }
    
    func earth_values(term_sum: [Double], count: Int) -> Double
    {
        var sum: Double = 0
        
        for i in 0 ..< count
        {    sum += term_sum[i] * pow(self.jme, Double(i)) }
        
        sum /= 1.0e8
        
        return sum
    }
    
    func earth_heliocentric_longitude() -> Double
    {
        var sum: [Double] = []
        
        for i in 0 ..< L_COUNT
        {
            sum.append( earth_periodic_term_summation(terms: L_TERMS[i], count: l_subcount[i]) )
        }
        return limit_degrees(rad2deg(earth_values(term_sum: sum, count: L_COUNT)))
    }
    
    func earth_heliocentric_latitude() -> Double
    {
        var sum: [Double] = []
        for i in 0 ..< B_COUNT
        {
            sum.append( earth_periodic_term_summation(terms: B_TERMS[i], count: b_subcount[i]) )
        }
        
        return rad2deg(earth_values(term_sum: sum, count: B_COUNT))
    }
    
    func earth_radius_vector() -> Double
    {
        var sum:[Double] = []
        
        for i in 0 ..< R_COUNT
        {
            sum.append( earth_periodic_term_summation(terms: R_TERMS[i], count: r_subcount[i]) )
        }
        
        return earth_values(term_sum: sum, count: R_COUNT)
    }
    
    func geocentric_longitude() -> Double
    {
        var theta: Double = self.l + 180.0
        
        if (theta >= 360.0) {theta -= 360.0}
        
        return theta
    }
    
    func geocentric_latitude() -> Double
    {
        return -self.b
    }
    
    func mean_elongation_moon_sun() -> Double
    {
        return third_order_polynomial(1.0/189474.0, -0.0019142, 445267.11148, 297.85036, self.jce)
    }
    
    func mean_anomaly_sun() -> Double
    {
        return third_order_polynomial(-1.0/300000.0, -0.0001603, 35999.05034, 357.52772, self.jce)
    }
    
    func mean_anomaly_moon() -> Double
    {
        return third_order_polynomial(1.0/56250.0, 0.0086972, 477198.867398, 134.96298, self.jce)
    }
    
    func argument_latitude_moon() -> Double
    {
        return third_order_polynomial(1.0/327270.0, -0.0036825, 483202.017538, 93.27191, self.jce)
    }
    
    func ascending_longitude_moon() -> Double
    {
        return third_order_polynomial(1.0/450000.0, 0.0020708, -1934.136261, 125.04452, self.jce)
    }
    
    func xy_term_summation(_ i: Int,_ x: [Double]) -> Double
    {
        var sum: Double = 0
        
        for j in 0 ..< TERM_Y_COUNT
        {
            sum += x[j] * Double(Y_TERMS[i][j])
        }
        
        return sum
    }
    
    mutating func nutation_longitude_and_obliquity(_ x: [Double])
    {
        var xy_term_sum: Double, sum_psi: Double = 0, sum_epsilon: Double = 0
        
        for i in 0 ..< Y_COUNT
        {
            xy_term_sum  = deg2rad(xy_term_summation(i, x))
            sum_psi     += (PE_TERMS[i][TERM_PSI_A] + jce * PE_TERMS[i][TERM_PSI_B]) * sin(xy_term_sum)
            sum_epsilon += (PE_TERMS[i][TERM_EPS_C] + jce * PE_TERMS[i][TERM_EPS_D]) * cos(xy_term_sum)
        }
        
        self.del_psi     = sum_psi     / 36000000.0
        self.del_epsilon = sum_epsilon / 36000000.0
    }
    
    func ecliptic_mean_obliquity() -> Double
    {
        let u: Double = self.jme / 10.0
        
        return 84381.448 + u*(-4680.93 + u*(-1.55 + u*(1999.25 + u*(-51.38 + u*(-249.67 +
            u*(  -39.05 + u*( 7.12 + u*(  27.87 + u*(  5.79 + u*2.45)))))))))
    }
    
    func ecliptic_true_obliquity() -> Double
    {
        return self.del_epsilon + self.epsilon0/3600.0;
    }
    
    func aberration_correction() -> Double
    {
        return -20.4898 / (3600.0 * self.r)
    }
    
    func apparent_sun_longitude() -> Double
    {
        return self.theta + self.del_psi + self.del_tau
    }
    
    func greenwich_mean_sidereal_time () -> Double
    {
        return limit_degrees(280.46061837 + 360.98564736629 * (self.jd - 2451545.0) + self.jc * self.jc * (0.000387933 - jc/38710000.0))
    }
    
    func greenwich_sidereal_time () -> Double
    {
        return self.nu0 + self.del_psi * cos(deg2rad(self.epsilon))
    }
    
    func geocentric_right_ascension() -> Double
    {
        let lamda_rad: Double = deg2rad(self.lamda)
        let epsilon_rad: Double = deg2rad(self.epsilon)
        
        return limit_degrees(rad2deg(atan2(sin(lamda_rad)*cos(epsilon_rad) - tan(deg2rad(self.beta))*sin(epsilon_rad), cos(lamda_rad))))
    }
    
    func geocentric_declination() -> Double
    {
        let beta_rad: Double = deg2rad(self.beta)
        let epsilon_rad: Double = deg2rad(self.epsilon)
        
        return rad2deg(asin(sin(beta_rad) * cos(epsilon_rad) + cos(beta_rad) * sin(epsilon_rad) * sin(deg2rad(self.lamda))))
    }
    
    func observer_hour_angle() -> Double
    {
        return limit_degrees(self.nu + self.longitude - self.alpha)
    }
    
    func sun_equatorial_horizontal_parallax() -> Double
    {
        return 8.794 / (3600.0 * self.r)
    }
    
    mutating func right_ascension_parallax_and_topocentric_dec()
    {
        let lat_rad: Double   = deg2rad(self.latitude)
        let xi_rad: Double    = deg2rad(self.xi)
        let h_rad: Double     = deg2rad(self.h)
        let delta_rad: Double = deg2rad(self.delta)
        let u: Double = atan(0.99664719 * tan(lat_rad))
        let y: Double = 0.99664719 * sin(u) + elevation*sin(lat_rad)/6378140.0
        let x: Double =              cos(u) + elevation*cos(lat_rad)/6378140.0
        
        let delta_alpha_rad: Double = atan2( -(x * sin(xi_rad) * sin(h_rad)), cos(delta_rad) - x * sin(xi_rad) * cos(h_rad))
        self.delta_prime = rad2deg(atan2((sin(delta_rad) - y*sin(xi_rad))*cos(delta_alpha_rad),cos(delta_rad) - x*sin(xi_rad) * cos(h_rad)))
        self.del_alpha = rad2deg(delta_alpha_rad)
    }
    
    func topocentric_right_ascension() -> Double
    {
        return self.alpha + self.del_alpha
    }
    
    func topocentric_local_hour_angle() -> Double
    {
        return self.h - self.del_alpha
    }
    
    func topocentric_elevation_angle() -> Double
    {
        let lat_rad: Double         = deg2rad(self.latitude)
        let delta_prime_rad: Double = deg2rad(self.delta_prime)
        
        return rad2deg(asin(sin(lat_rad)*sin(delta_prime_rad) + cos(lat_rad)*cos(delta_prime_rad) * cos(deg2rad(self.h_prime))))
    }
    
    func atmospheric_refraction_correction() -> Double
    {
        var del_e: Double = 0
        
        if ( self.e0 >= ( -1 * (SUN_RADIUS + self.atmos_refract)) )
        {
            del_e = (self.pressure / 1010.0) * (283.0 / (273.0 + self.temperature)) * 1.02 / (60.0 * tan(deg2rad(self.e0 + 10.3/(self.e0 + 5.11))))
        }
        return del_e
    }
    
    func topocentric_elevation_angle_corrected() -> Double
    {
        return self.e0 + self.del_e
    }
    
    func topocentric_zenith_angle() -> Double
    {
        return 90.0 - self.e
    }
    
    func topocentric_azimuth_angle_astro() -> Double
    {
        let h_prime_rad: Double = deg2rad(self.h_prime)
        let lat_rad: Double = deg2rad(self.latitude)
        
        return limit_degrees(rad2deg(atan2(sin(h_prime_rad), cos(h_prime_rad)*sin(lat_rad) - tan(deg2rad(self.delta_prime))*cos(lat_rad))))
    }
    
    func topocentric_azimuth_angle() -> Double
    {
        return limit_degrees(self.azimuth_astro + 180.0)
    }
    
    func surface_incidence_angle() -> Double
    {
        let zenith_rad: Double = deg2rad(self.zenith)
        let slope_rad: Double = deg2rad(self.slope)
        
        return rad2deg(acos(cos(zenith_rad)*cos(slope_rad) + sin(slope_rad) * sin(zenith_rad) * cos(deg2rad(self.azimuth_astro - self.azm_rotation))))
    }
    
    func surface_declination_angle() -> Double
    {
        return 90 - self.incidence
    }
    
    //MARK: - Calculate SPA Parameters
    ///////////////////////////////////////////////////////////////////////////////////////////////
    // Calculate required SPA parameters to get the right ascension (alpha) and declination (delta)
    // Note: JD must be already calculated and in structure
    ////////////////////////////////////////////////////////////////////////////////////////////////
    mutating func calculate_geocentric_sun_right_ascension_and_declination()
    {
        var x:[Double] = [] //double x[TERM_X_COUNT]
        
        self.jc = julian_century()
        
        self.jde = julian_ephemeris_day()
        self.jce = julian_ephemeris_century()
        self.jme = julian_ephemeris_millennium()
        
        self.l = earth_heliocentric_longitude()
        self.b = earth_heliocentric_latitude()
        self.r = earth_radius_vector()
        
        self.theta = geocentric_longitude()
        self.beta  = geocentric_latitude()
        
        self.x0 = mean_elongation_moon_sun()
        self.x1 = mean_anomaly_sun()
        self.x2 = mean_anomaly_moon()
        self.x3 = argument_latitude_moon()
        self.x4 = ascending_longitude_moon()
        
        x.append( self.x0 )
        x.append( self.x1 )
        x.append( self.x2 )
        x.append( self.x3 )
        x.append( self.x4 )
        
        nutation_longitude_and_obliquity(x)
        
        self.epsilon0 = ecliptic_mean_obliquity()
        self.epsilon  = ecliptic_true_obliquity()
        
        self.del_tau   = aberration_correction()
        self.lamda     = apparent_sun_longitude()
        self.nu0       = greenwich_mean_sidereal_time()
        self.nu        = greenwich_sidereal_time()
        
        self.alpha = geocentric_right_ascension()
        self.delta = geocentric_declination()
    }

    ///////////////////////////////////////////////////////////////////////////////////////////
    // Calculate all SPA parameters and put into structure
    // Note: All inputs values (listed in header file) must already be in structure
    ///////////////////////////////////////////////////////////////////////////////////////////
    mutating func spa_calculate()
    {
        parseDate()
        let result: Int = validate_inputs()
        
        if (result == 0)
        {
            self.jd = julian_day()
            
            calculate_geocentric_sun_right_ascension_and_declination()
            
            self.h  = observer_hour_angle()
            self.xi = sun_equatorial_horizontal_parallax()
            
            right_ascension_parallax_and_topocentric_dec()
            
            self.alpha_prime = topocentric_right_ascension()
            self.h_prime     = topocentric_local_hour_angle()
            
            self.e0      = topocentric_elevation_angle()
            self.del_e   = atmospheric_refraction_correction()
            self.e       = topocentric_elevation_angle_corrected()
            
            self.zenith        = topocentric_zenith_angle()
            self.azimuth_astro = topocentric_azimuth_angle_astro()
            self.azimuth       = topocentric_azimuth_angle()
            
            if ((self.function == SPA_ZA_INC) || (self.function == SPA_ALL))
            {
                self.incidence  = surface_incidence_angle()
                self.declination = surface_declination_angle()
            }
            
//            if ((function == SPA_ZA_RTS) || (function == SPA_ALL))
//            {
//                calculate_eot_and_sun_rise_transit_set()
//            }
        }
        else
        {
            print("Error Code : \(result)")
        }
    }
    
    /*
    ///////////////////////////////////////////////////////////////////////////////////////////
    /*  SPA_ZA_RTS : Sun Rise/Transit/Set values */
    ///////////////////////////////////////////////////////////////////////////////////////////
    func sun_mean_longitude() -> Double
    {
        return limit_degrees(280.4664567 + self.jme*(360007.6982779 + self.jme*(0.03032028 + self.jme*(1/49931.0 + self.jme * (-1/15300.0     + self.jme*(-1/2000000.0))))))
    }
    
    func equation_of_time(_ m: Double) -> Double
    {
        return limit_minutes(4.0*(m - 0.0057183 - self.alpha + self.del_psi * cos(deg2rad(self.epsilon))))
    }
    
    func approx_sun_transit_time(_ alpha_zero: Double) -> Double
    {
        return (alpha_zero - self.longitude - self.nu) / 360.0
    }
    
    func sun_hour_angle_at_rise_set(_ delta_zero: Double,_ h0_prime: Double) -> Double
    {
        var h0: Double             = -99999
        let latitude_rad: Double   = deg2rad(self.latitude)
        let delta_zero_rad: Double = deg2rad(delta_zero)
        let argument: Double = (sin(deg2rad(h0_prime)) - sin(latitude_rad) * sin(delta_zero_rad)) / (cos(latitude_rad) * cos(delta_zero_rad))
        
        if (fabs(argument) <= 1) { h0 = limit_degrees180(rad2deg(acos(argument))) }
        
        return h0
    }
    
    func approx_sun_rise_and_set(_ m_rts: inout [Double], h0: Double)
    {
        let h0_dfrac: Double = h0/360.0
        
        m_rts.append(limit_zero2one(m_rts[SUN_TRANSIT] - h0_dfrac))  //SUN_RISE
        m_rts.append(limit_zero2one(m_rts[SUN_TRANSIT] + h0_dfrac))  //SUN_SET
        m_rts.append(limit_zero2one(m_rts[SUN_TRANSIT]))  //SUN_TRANSIT
    }
    
    func rts_alpha_delta_prime(ad: inout [Double], n: Double) -> Double
    {
        var a: Double = ad[JD_ZERO] - ad[JD_MINUS]
        var b: Double = ad[JD_PLUS] - ad[JD_ZERO]
        
        if (fabs(a) >= 2.0) { a = limit_zero2one(a) }
        if (fabs(b) >= 2.0) { b = limit_zero2one(b) }
        
        return ad[JD_ZERO] + n * (a + b + (b-a) * n) / 2.0
    }
    
    func rts_sun_altitude( _ delta_prime: Double, _ h_prime: Double) -> Double
    {
        let latitude_rad: Double    = deg2rad(self.latitude)
        let delta_prime_rad: Double = deg2rad(delta_prime)
        
        return rad2deg(asin(sin(latitude_rad)*sin(delta_prime_rad) + cos(latitude_rad)*cos(delta_prime_rad)*cos(deg2rad(h_prime))))
    }
    
    func sun_rise_and_set(_ m_rts: inout [Double],_ h_rts: inout [Double],_ delta_prime: inout [Double], _ h_prime: inout [Double],_ h0_prime: Double,_ sun: Int) -> Double
    {
        return m_rts[sun] + (h_rts[sun] - h0_prime) / (360.0 * cos(deg2rad(delta_prime[sun])) * cos(deg2rad(self.latitude)) * sin(deg2rad(h_prime[sun])))
    }
    
    
    ////////////////////////////////////////////////////////////////////////
    // Calculate Equation of Time (EOT) and Sun Rise, Transit, & Set (RTS)
    ////////////////////////////////////////////////////////////////////////
    func calculate_eot_and_sun_rise_transit_set()
    {
        var alpha: [Double] = [], delta: [Double] = []
        var m_rts: [Double] = [], nu_rts: [Double] = [], h_rts: [Double] = []
        var alpha_prime: [Double] = [], delta_prime: [Double] = [], h_prime: [Double] = []
        let h0_prime: Double = -1 * (SUN_RADIUS + self.atmos_refract)
        
        let m = sun_mean_longitude()
        self.eot = equation_of_time(m)
        
        self.hour = 0
        self.minute = 0
        self.second = 0
        self.delta_ut1 = 0
        self.timezone = 0
        self.jd = julian_day()
        
        calculate_geocentric_sun_right_ascension_and_declination()
        
        self.delta_t = 0
        self.jd -= 1
        for i in 0 ..< JD_COUNT
        {
            calculate_geocentric_sun_right_ascension_and_declination()
            alpha.append(self.alpha)
            delta.append(self.delta)
            self.jd += 1
        }
        
        m_rts.append(approx_sun_transit_time(alpha[JD_ZERO]))   //SUN_TRANSIT
        let h0 = sun_hour_angle_at_rise_set(delta[JD_ZERO], h0_prime)
        
        if (h0 >= 0) {
            
            approx_sun_rise_and_set(&m_rts, h0: h0)
            
            for i in 0 ..< SUN_COUNT
            {
                nu_rts.append(self.nu + 360.985647 * m_rts[i])
                
                let n              = m_rts[i] + self.delta_t / 86400.0
                alpha_prime.append(rts_alpha_delta_prime(ad: &alpha, n: n))
                delta_prime.append(rts_alpha_delta_prime(ad: &delta, n: n))
                
                h_prime.append(limit_degrees180pm(nu_rts[i] + self.longitude - alpha_prime[i]))
                
                h_rts.append(rts_sun_altitude(delta_prime[i], h_prime[i]))
            }
            
            self.srha = h_prime[SUN_RISE]
            self.ssha = h_prime[SUN_SET]
            self.sta  = h_rts[SUN_TRANSIT]
            
            self.suntransit = dayfrac_to_local_hr(m_rts[SUN_TRANSIT] - h_prime[SUN_TRANSIT] / 360.0)
            
            self.sunrise = dayfrac_to_local_hr(sun_rise_and_set(&m_rts, &h_rts, &delta_prime, &h_prime, h0_prime, SUN_RISE))
            
            self.sunset  = dayfrac_to_local_hr(sun_rise_and_set(&m_rts, &h_rts, &delta_prime, &h_prime, h0_prime, SUN_SET))
            
        }
        else
        {
            self.srha = -99999
            self.ssha = -99999
            self.sta = -99999
            self.suntransit = -99999
            self.sunrise = -99999
            self.sunset = -99999
        }
        
    }
    */
}
