
function day(d,m,y) {return 365 * (y - StartYear) + days[m] + d}

function date(d)   {y = int(d/365) + StartYear
                    YearDay = d % 365
                    if (YearDay <= 31) {m = "Jan"; d = YearDay}
                    else if (YearDay <= 61) {m = "Feb"; d = YearDay - 31}
                    else if (YearDay <= 89) {m = "Mar"; d = YearDay - 61}
                    else if (YearDay <= 120) {m = "Apr"; d = YearDay - 89}
                    else if (YearDay <= 150) {m = "May"; d = YearDay - 120}
                    else if (YearDay <= 181) {m = "Jun"; d = YearDay - 150}
                    else if (YearDay <= 212) {m = "Jul"; d = YearDay - 181}
                    else if (YearDay <= 243) {m = "Aug"; d = YearDay - 212}
                    else if (YearDay <= 273) {m = "Sep"; d = YearDay - 243}
                    else if (YearDay <= 304) {m = "Oct"; d = YearDay - 273}
                    else if (YearDay <= 334) {m = "Nov"; d = YearDay - 304}
                    else {m = "Dec"; d = YearDay - 334}
                    return d " " m " " y
                   }

function shuffle_weeks(day,words) {
  week_words[4] = week_words[3]
  week_day[4] = week_day[3]
  week_words[3] = week_words[2]
  week_day[3] = week_day[2]
  week_words[2] = week_words[1]
  week_day[2] = week_day[1]
  week_words[1] = words
  week_day[1] = day
    }

BEGIN {StartYear = 1997
       MaxWords = 60000
       StartDate = 156
       Deadline = 426

       days["Jan"] = 0
       days["Feb"] = 31
       days["Mar"] = 61
       days["Apr"] = 89
       days["May"] = 120
       days["Jun"] = 150
       days["Jul"] = 181
       days["Aug"] = 212
       days["Sep"] = 243
       days["Oct"] = 273
       days["Nov"] = 304
       days["Dec"] = 334
       week_day[1] = 0
       week_words[1] = 0
       week_day[2] = 0
       week_words[2] = 0
       week_day[3] = 0
       week_words[3] = 0
       week_day[4] = 0
       week_words[4] = 0
      }

      {CurrentDay = day($3,$2,$6)
       CurrentWords = $7
       if (CurrentDay >= (week_day[1] + 7)) shuffle_weeks(CurrentDay,$7)
       CurrentFinish = day($8,$9,$10)
       print CurrentDay, CurrentWords, CurrentFinish, \
             (CurrentDay - StartDate) * MaxWords / (Deadline - StartDate)
      }

END { FinishDay = int(week_day[4] + \
          (CurrentDay - week_day[4]) * (MaxWords - week_words[4]) / \
          (CurrentWords - week_words[4]))

      print CurrentDay, CurrentWords, CurrentFinish, \
             (CurrentFinish - StartDate) * MaxWords / (Deadline - StartDate)

      print date(FinishDay) | "cat 1>&2"

      print week_day[4], week_words[4] >"words.forecast"
      print FinishDay, MaxWords >>"words.forecast"
	}


