#import "NSDate+Escort.h"
#import "NSDateAdditions.h"
#define SECONDS_IN_MINUTE 60
#define MINUTES_IN_HOUR 60
#define DAYS_IN_WEEK 7
#define SECONDS_IN_HOUR (SECONDS_IN_MINUTE * MINUTES_IN_HOUR)
#define HOURS_IN_DAY 24
#define SECONDS_IN_DAY (HOURS_IN_DAY * SECONDS_IN_HOUR)

@implementation NSDate (Escort)
#pragma mark - private
+ (NSCalendar *)AZ_currentCalendar {
    NSMutableDictionary *dictionary = [[NSThread currentThread] threadDictionary];
    NSCalendar *currentCalendar = [dictionary objectForKey:@"AZ_currentCalendar"];
    if (currentCalendar == nil) {
        currentCalendar = [NSCalendar currentCalendar];
        [dictionary setObject:currentCalendar forKey:@"AZ_currentCalendar"];
    }
    return currentCalendar;
}

+ (NSDate*)dateFormString:(NSString*)dateStr format:(NSString*)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    [dateFormatter release];
    return [date dateByLocalTimeZone];
}
- (NSString *)dateToStringWithFormat:(NSString*)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *strDate = [dateFormatter stringFromDate:self];
    [dateFormatter release];
    return strDate;
}
#pragma mark - Relative dates from the current date
+ (NSDate *)dateTomorrow {
    NSTimeInterval timeInterval = [NSDate timeIntervalSinceReferenceDate] + (SECONDS_IN_DAY * 1);
    return [[NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval] dateByLocalTimeZone];
}

+ (NSDate *)dateYesterday {
    NSTimeInterval timeInterval = [NSDate timeIntervalSinceReferenceDate] - (SECONDS_IN_DAY * 1);
    return [[NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval] dateByLocalTimeZone];
}

+ (NSDate *)dateWithDaysFromNow:(NSInteger) dDays {
    NSTimeInterval timeInterval = [NSDate timeIntervalSinceReferenceDate] + (SECONDS_IN_DAY * dDays);
    return [[NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval] dateByLocalTimeZone];
}

+ (NSDate *)dateWithDaysBeforeNow:(NSInteger) dDays {
    NSTimeInterval timeInterval = [NSDate timeIntervalSinceReferenceDate] - (SECONDS_IN_DAY * dDays);
    return [[NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval] dateByLocalTimeZone];
}

+ (NSDate *)dateWithHoursFromNow:(NSInteger) dHours {
    NSTimeInterval timeInterval = [NSDate timeIntervalSinceReferenceDate] + (SECONDS_IN_HOUR * dHours);
    return [[NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval] dateByLocalTimeZone];
}

+ (NSDate *)dateWithHoursBeforeNow:(NSInteger) dHours {
    NSTimeInterval timeInterval = [NSDate timeIntervalSinceReferenceDate] - (SECONDS_IN_HOUR * dHours);
    return [[NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval] dateByLocalTimeZone];
}

+ (NSDate *)dateWithMinutesFromNow:(NSInteger) dMinutes {
    NSTimeInterval timeInterval = [NSDate timeIntervalSinceReferenceDate] + (SECONDS_IN_MINUTE * dMinutes);
    return [[NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval] dateByLocalTimeZone];
}

+ (NSDate *)dateWithMinutesBeforeNow:(NSInteger) dMinutes {
    NSTimeInterval timeInterval = [NSDate timeIntervalSinceReferenceDate] - (SECONDS_IN_MINUTE * dMinutes);
    return [[NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval] dateByLocalTimeZone];
}

#pragma mark - Comparing dates




- (BOOL)isEqualToDateIgnoringTime:(NSDate *) otherDate {
    NSCalendar *currentCalendar = [NSDate AZ_currentCalendar];
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *components1 = [currentCalendar components:unitFlags fromDate:self];
    NSDateComponents *components2 = [currentCalendar components:unitFlags fromDate:otherDate];
    return (components1.year == components2.year) &&
        (components1.month == components2.month) &&
        (components1.day == components2.day);
}

- (BOOL)isToday {
    return [self isEqualToDateIgnoringTime:[[NSDate date] dateByLocalTimeZone]];
}

- (BOOL)isTomorrow {
    return [self isEqualToDateIgnoringTime:[NSDate dateTomorrow]];
}

- (BOOL)isYesterday {
    return [self isEqualToDateIgnoringTime:[NSDate dateYesterday]];
}

- (BOOL)isSameWeekAsDate:(NSDate *) aDate {
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    NSDateComponents *components1 = [calendar components:NSCalendarUnitWeekOfYear fromDate:self];
    NSDateComponents *components2 = [calendar components:NSCalendarUnitWeekOfYear fromDate:aDate];
    if (components1.weekOfYear != components2.weekOfYear) {
        return NO;
    }
    return (fabs([self timeIntervalSinceDate:aDate]) < (SECONDS_IN_DAY * DAYS_IN_WEEK));
}

- (BOOL)isThisWeek {
    return [self isSameWeekAsDate:[[NSDate date] dateByLocalTimeZone]];
}

- (BOOL)isNextWeek {
    NSDate *nextWeek = [NSDate dateWithDaysFromNow:DAYS_IN_WEEK];
    return [self isSameWeekAsDate:nextWeek];
}

- (BOOL)isLastWeek {
    NSDate *lastWeek = [NSDate dateWithDaysBeforeNow:DAYS_IN_WEEK];
    return [self isSameWeekAsDate:lastWeek];
}

- (BOOL)isSameMonthAsDate:(NSDate *) aDate {
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    NSDateComponents *componentsSelf = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:self];
    NSDateComponents *componentsArgs = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:aDate];
    if (componentsSelf.year != componentsArgs.year || componentsSelf.month != componentsArgs.month) {
        return NO;
    }
    return YES;
}

- (BOOL)isThisMonth {
    return [self isSameMonthAsDate:[[NSDate date] dateByLocalTimeZone]];
}

- (BOOL)isSameYearAsDate:(NSDate *) aDate {
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    NSDateComponents *componentsSelf = [calendar components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *componentsArgs = [calendar components:NSCalendarUnitYear fromDate:aDate];
    if (componentsSelf.year != componentsArgs.year) {
        return NO;
    }
    return YES;
}

- (BOOL)isThisYear {
    return [self isSameYearAsDate:[[NSDate date] dateByLocalTimeZone]];
}

- (BOOL)isNextYear {
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    NSDateComponents *componentsSelf = [calendar components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *componentsNextYear = [calendar components:NSCalendarUnitYear fromDate:[[NSDate date] dateByLocalTimeZone]];
    componentsNextYear.year += 1;
    if (componentsSelf.year != componentsNextYear.year) {
        return NO;
    }
    return YES;
}

- (BOOL)isLastYear {
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    NSDateComponents *componentsSelf = [calendar components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *componentsLastYear = [calendar components:NSCalendarUnitYear fromDate:[[NSDate date] dateByLocalTimeZone]];
    componentsLastYear.year -= 1;
    if (componentsSelf.year != componentsLastYear.year) {
        return NO;
    }
    return YES;
}

- (BOOL)isEarlierThanDate:(NSDate *) aDate {
    return ([self compare:aDate] == NSOrderedAscending);
}
- (BOOL)isEarlierThanDateIgnoringTime:(NSDate *) aDate {
    NSDate *date1 = [NSDate dateFormString:[self format:@"yyyy-MM-dd"] format:@"yyyy-MM-dd"];
    NSDate *date2 = [NSDate dateFormString:[aDate format:@"yyyy-MM-dd"] format:@"yyyy-MM-dd"];
    return ([date1 compare:date2] == NSOrderedAscending);
}
- (BOOL)isLaterThanDate:(NSDate *) aDate {
    return ([self compare:aDate] == NSOrderedDescending);
}
- (BOOL)isLaterThanDateIgnoringTime:(NSDate *) aDate {
    NSDate *date1 = [NSDate dateFormString:[self format:@"yyyy-MM-dd"] format:@"yyyy-MM-dd"];
    NSDate *date2 = [NSDate dateFormString:[aDate format:@"yyyy-MM-dd"] format:@"yyyy-MM-dd"];
    return ([date1 compare:date2] == NSOrderedDescending);
}
- (BOOL)isEarlierThanOrEqualDate:(NSDate *) aDate {
    NSComparisonResult comparisonResult = [self compare:aDate];
    return (comparisonResult == NSOrderedAscending) || (comparisonResult == NSOrderedSame);
}

- (BOOL)isLaterThanOrEqualDate:(NSDate *) aDate {
    NSComparisonResult comparisonResult = [self compare:aDate];
    return (comparisonResult == NSOrderedDescending) || (comparisonResult == NSOrderedSame);
}

- (BOOL)isInPast {
    return [self isEarlierThanDate:[[NSDate date] dateByLocalTimeZone]];
}

- (BOOL)isInFuture {
    return [self isLaterThanDate:[[NSDate date] dateByLocalTimeZone]];
}


#pragma mark - Date roles
// https://github.com/erica/NSDate-Extensions/issues/12
- (BOOL)isTypicallyWorkday {
    return ([self isTypicallyWeekend] == NO);
}

- (BOOL)isTypicallyWeekend {
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    NSRange weekdayRange = [calendar maximumRangeOfUnit:NSCalendarUnitWeekday];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:self];
    NSInteger weekdayOfDate = [components weekday];
    if (weekdayOfDate == weekdayRange.location || weekdayOfDate == weekdayRange.length) {
        return YES;
    }
    return NO;
}

#pragma mark - Adjusting dates

- (NSDate*)dateByLocalTimeZone
{
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSInteger interval = [zone secondsFromGMTForDate:self];
//    NSDate *localeDate = [self dateByAddingTimeInterval:interval];
    
    return self;
    
}

- (NSDate *)dateByAddingYears:(NSInteger) dYears {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = dYears;
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    return [[calendar dateByAddingComponents:components toDate:self options:0] dateByLocalTimeZone];
}

- (NSDate *)dateBySubtractingYears:(NSInteger) dYears {
    return [self dateByAddingYears:-dYears];
}

- (NSDate *)dateByAddingMonths:(NSInteger) dMonths {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = dMonths;
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    return [[calendar dateByAddingComponents:components toDate:self options:0] dateByLocalTimeZone];
}

- (NSDate *)dateBySubtractingMonths:(NSInteger) dMonths {
    return [self dateByAddingMonths:-dMonths];
}

- (NSDate *)dateByAddingDays:(NSInteger) dDays {
    
    NSTimeInterval a_day = 24*60*60*dDays;
    NSDate *newDate = [self dateByAddingTimeInterval: a_day];
    return newDate;
   
}

- (NSDate *)dateBySubtractingDays:(NSInteger) dDays {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = -dDays;
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    return [[calendar dateByAddingComponents:components toDate:self options:0] dateByLocalTimeZone];

}

- (NSDate *)dateByAddingHours:(NSInteger) dHours {
    return [[self dateByAddingTimeInterval:(SECONDS_IN_HOUR * dHours)] dateByLocalTimeZone];
}

- (NSDate *)dateBySubtractingHours:(NSInteger) dHours {
    return [[self dateByAddingTimeInterval:-(SECONDS_IN_HOUR * dHours)] dateByLocalTimeZone];
}

- (NSDate *)dateByAddingMinutes:(NSInteger) dMinutes {
    return [[self dateByAddingTimeInterval:(SECONDS_IN_MINUTE * dMinutes)] dateByLocalTimeZone];
}

- (NSDate *)dateBySubtractingMinutes:(NSInteger) dMinutes {
    return [[self dateByAddingTimeInterval:-(SECONDS_IN_MINUTE * dMinutes)] dateByLocalTimeZone];
}

- (NSDate *)dateAtStartOfDay {
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:self];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    

    
    return [[calendar dateFromComponents:components] dateByLocalTimeZone];
}

- (NSDate *)dateAtEndOfDay {
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:self];
    components.hour = 23;
    components.minute = 59;
    components.second = 59;
    return [[calendar dateFromComponents:components] dateByLocalTimeZone];
}

- (NSDate *)dateAtStartOfWeek {
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
//    calendar.firstWeekday = 0;
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:self];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfYear forDate:self];
    components.day = range.location;
    return [[calendar dateFromComponents:components] dateByLocalTimeZone];
}

- (NSDate *)dateAtEndOfWeek {
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:self];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfYear forDate:self];
    components.day = range.length+range.location;
    
//    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self];
    
    
//    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
//    [componentsToAdd setDay: + (((([components weekday] - [calendar firstWeekday])
//                                  + 7 ) % 7))+6];
//    NSDate *endOfWeek = [calendar dateByAddingComponents:componentsToAdd toDate:[NSDate date] options:0];
//    
//    NSDateComponents *componentsStripped = [calendar components: (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
//                                                        fromDate: endOfWeek];
//    
//    //gestript
//    endOfWeek = [calendar dateFromComponents: componentsStripped];
    return [[calendar dateFromComponents:components] dateByLocalTimeZone];
}

- (NSDate *)dateAtStartOfMonth {
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:self];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    components.day = range.location;
    return [[calendar dateFromComponents:components] dateByLocalTimeZone];
}

- (NSDate *)dateAtEndOfMonth {
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:self];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    components.day = range.length;
    return [[calendar dateFromComponents:components] dateByLocalTimeZone];
}

- (NSDate *)dateAtStartOfYear {
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:self];
    NSRange monthRange = [calendar rangeOfUnit:NSCalendarUnitMonth inUnit:NSCalendarUnitYear forDate:self];
    NSRange dayRange = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    components.day = dayRange.location;
    components.month = monthRange.location;
    NSDate *startOfYear = [calendar dateFromComponents:components];
    return [startOfYear dateByLocalTimeZone];
}

- (NSDate *)dateAtEndOfYear {
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:self];
    NSRange monthRange = [calendar rangeOfUnit:NSCalendarUnitMonth inUnit:NSCalendarUnitYear forDate:self];
    NSRange dayRange = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    components.day = dayRange.length;
    components.month = monthRange.length;
    NSDate *endOfYear = [calendar dateFromComponents:components];
    return [endOfYear dateByLocalTimeZone];
}


#pragma mark - Retrieving intervals
- (NSInteger)minutesAfterDate:(NSDate *) aDate {
    NSTimeInterval timeIntervalSinceDate = [self timeIntervalSinceDate:aDate];
    return (NSInteger)(timeIntervalSinceDate / SECONDS_IN_MINUTE);
}

- (NSInteger)minutesBeforeDate:(NSDate *) aDate {
    NSTimeInterval timeIntervalSinceDate = [aDate timeIntervalSinceDate:self];
    return (NSInteger)(timeIntervalSinceDate / SECONDS_IN_MINUTE);
}

- (NSInteger)hoursAfterDate:(NSDate *) aDate {
    NSTimeInterval timeIntervalSinceDate = [self timeIntervalSinceDate:aDate];
    return (NSInteger)(timeIntervalSinceDate / SECONDS_IN_HOUR);
}

- (NSInteger)hoursBeforeDate:(NSDate *) aDate {
    NSTimeInterval timeIntervalSinceDate = [aDate timeIntervalSinceDate:self];
    return (NSInteger)(timeIntervalSinceDate / SECONDS_IN_HOUR);
}

- (NSInteger)daysAfterDate:(NSDate *) aDate {
    NSTimeInterval timeIntervalSinceDate = [self timeIntervalSinceDate:aDate];
    return (NSInteger)(timeIntervalSinceDate / SECONDS_IN_DAY);
}

- (NSInteger)daysBeforeDate:(NSDate *) aDate {
    NSTimeInterval timeIntervalSinceDate = [aDate timeIntervalSinceDate:self];
    return (NSInteger)(timeIntervalSinceDate / SECONDS_IN_DAY);
}

- (NSInteger)monthsAfterDate:(NSDate *) aDate {
    NSInteger result = (self.gregorianYear - aDate.gregorianYear) * 12 + (self.month - aDate.month);

    if (result == 0) {
        return 0;
    } else if (0 < result) {
        if (aDate.day < self.day || (aDate.day == self.day && [self timeIntervalIgnoringDay:aDate] <= 0)) {
            return result;
        } else {
            return result - 1;
        }
    } else {
        if (self.day < aDate.day || (self.day == aDate.day && 0 <= [self timeIntervalIgnoringDay:aDate])) {
            return result;
        } else {
            return result + 1;
        }
    }
}

- (NSInteger)monthsBeforeDate:(NSDate *) aDate {
    return -[self monthsAfterDate:aDate];
}

- (NSTimeInterval)timeIntervalIgnoringDay:(NSDate *) aDate {
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    enum NSCalendarUnit unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:unitFlags fromDate:aDate];
    NSDateComponents *components1 = [calendar components:unitFlags fromDate:self];
    return [[calendar dateFromComponents:components] timeIntervalSinceDate:[calendar dateFromComponents:components1]];
}

- (NSInteger)distanceInDaysToDate:(NSDate *) aDate {
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    NSDateComponents *dateComponents = [calendar
        components:NSCalendarUnitDay fromDate:self toDate:aDate options:0];
    return [dateComponents day];
}
#pragma mark - Decomposing dates
// NSDate-Utilities API is broken?
- (NSInteger)nearestHour {
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    NSRange minuteRange = [calendar rangeOfUnit:NSCalendarUnitMinute inUnit:NSCalendarUnitHour forDate:self];
    // always 30...
    NSInteger halfMinuteInHour = minuteRange.length / 2;
    NSInteger currentMinute = self.minute;
    if (currentMinute < halfMinuteInHour) {
        return self.hour;
    } else {
        NSDate *anHourLater = [self dateByAddingHours:1];
        return [anHourLater hour];
    }
}

- (NSInteger)hour {
    NSCalendar *calendar = [NSDate AZ_currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitHour fromDate:self];
    return [components hour];
}

- (NSInteger)minute {
    NSCalendar *calendar = [NSDate AZ_currentCalendar];

    NSDateComponents *components = [calendar components:NSCalendarUnitMinute fromDate:self];
    return [components minute];
}

- (NSInteger)seconds {
    NSCalendar *calendar = [NSDate AZ_currentCalendar];

    NSDateComponents *components = [calendar components:NSCalendarUnitSecond fromDate:self];
    return [components second];
}

- (NSInteger)day {
    NSCalendar *calendar = [NSDate AZ_currentCalendar];

    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:self];
    return [components day];
}

- (NSInteger)month {
    NSCalendar *calendar = [NSDate AZ_currentCalendar];

    NSDateComponents *components = [calendar components:NSCalendarUnitMonth fromDate:self];
    return [components month];
}

- (NSInteger)week {
    NSCalendar *calendar = [NSDate AZ_currentCalendar];

    NSDateComponents *components = [calendar components:NSCalendarUnitWeekOfYear fromDate:self];
    return [components weekOfYear];
}

- (NSInteger)weekday {
    NSCalendar *calendar = [NSDate AZ_currentCalendar];

    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:self];
    return [components weekday];
}

// http://stackoverflow.com/questions/11681815/current-week-start-and-end-date
- (NSInteger)firstDayOfWeekday {
    NSDate *startOfTheWeek;
    NSTimeInterval interval;
    [[NSDate AZ_currentCalendar] rangeOfUnit:NSCalendarUnitWeekOfYear
                                 startDate:&startOfTheWeek
                                 interval:&interval
                                 forDate:self];
    return [startOfTheWeek day];
}

- (NSInteger)lastDayOfWeekday {
    return [self firstDayOfWeekday] + (DAYS_IN_WEEK - 1);
}

- (NSInteger)nthWeekday {
    NSDateComponents *components = [[NSDate AZ_currentCalendar] components:NSCalendarUnitWeekdayOrdinal fromDate:self];
    return [components weekdayOrdinal];
}

- (NSInteger)year {
    NSDateComponents *components = [[NSDate AZ_currentCalendar] components:NSCalendarUnitYear fromDate:self];
    return [components year];
}
- (NSInteger)gregorianYear {
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [currentCalendar components:NSCalendarUnitEra | NSCalendarUnitYear fromDate:self];
    return [components year];
}

- (NSInteger)weeksInYear
{
    NSDateComponents *compt = [[NSDateComponents alloc] init];
    
    [compt setYear:[self year]];
    [compt setMonth:[self month]];
    [compt setDay:[self day]];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *date = [calendar dateFromComponents:compt];
    
    //[calendar setMinimumDaysInFirstWeek:6];
    NSInteger count = [calendar ordinalityOfUnit:NSCalendarUnitWeekOfYear inUnit:NSCalendarUnitYear forDate:date];
    return count;
}

@end