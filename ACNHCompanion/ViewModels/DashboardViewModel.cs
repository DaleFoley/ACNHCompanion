using ACNHCompanion.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Globalization;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading;
using System.Threading.Tasks;
using Xamarin.Forms;

namespace ACNHCompanion.ViewModels
{
    public class DashboardViewModel : ObservableObject
    {
        private Dictionary<string, int> _months = new Dictionary<string, int>()
        {
            { "january", 1},
            { "february", 2},
            { "march", 3},
            { "april", 4},
            { "may", 5},
            { "june", 6},
            { "july", 7},
            { "august", 8},
            { "september", 9},
            { "october", 10},
            { "november", 11},
            { "december", 12},
        };

        private DateTime _localTime;
        public DateTime LocalTime
        {
            get
            {
                return _localTime;
            }

            set
            {
                if(value != _localTime)
                {
                    _localTime = value;
                    OnNotifyPropertyChanged(nameof(LocalTime));
                }
            }
        }

        private List<Villagers> _villagersWithBirthdays;
        public List<Villagers> VillagersWithBirthdays
        {
            get { return _villagersWithBirthdays; }
            set { if (value != _villagersWithBirthdays) { _villagersWithBirthdays = value; OnNotifyPropertyChanged(nameof(VillagersWithBirthdays)); } }
        }

        public DashboardViewModel()
        {
            RefreshLocalTime();
            Device.StartTimer(TimeSpan.FromSeconds(1), () => UpdateLocalTime());

            _villagersWithBirthdays = App.ApplicationDatabase.GetVillagerResidents();
            _villagersWithBirthdays = _villagersWithBirthdays.Where(villager => IsVillagerBirthdayThisMonth(villager.Birthday))
                .OrderBy(villager => villager.Birthday).ToList();

            DateTime nextEventTime = new DateTime(LocalTime.Year, 4, 1);

            IsNextEvent(true, LocalTime, nextEventTime);
        }

        public bool IsNextEvent(bool isIntervalBased, DateTime currentTime, DateTime eventTime)
        {
            DateTime nextEventDateTime;

            if(isIntervalBased)
            {
                nextEventDateTime = GetEventDateTime(eventTime);
            }
            else
            {
                nextEventDateTime = eventTime;
            }

            return currentTime < nextEventDateTime;
        }

        public DateTime GetEventDateTime(DateTime eventTime)
        {
            Calendar eventCalendar = CultureInfo.InvariantCulture.Calendar;

            int eventMonthTotalDays = eventCalendar.GetDaysInMonth(eventTime.Year, eventTime.Month);
            
            //In the database we actually store an integer to denote interval instead of an actual day number in the month
            //i.e 2 for second saturday of the month, 3 for third of the month etc..
            int eventInterval = eventTime.Day;
            int eventIntervalCount = 0;

            for (int idx = 0; idx < eventMonthTotalDays || eventIntervalCount == eventInterval; idx++)
            {
                DayOfWeek dow = eventTime.DayOfWeek;
                if(dow == DayOfWeek.Saturday) { eventIntervalCount++; continue; }

                eventTime.AddDays(1);
            }

            return eventTime;
        }

        public bool IsVillagerBirthdayThisMonth(string villagerBirthday)
        {
            string[] villagerBirthdaySplit = villagerBirthday.Split(' ');
            if (villagerBirthdaySplit.Length != 2) { return false; }

            string villagerMonthName = villagerBirthdaySplit[0];

            int currentMonth = LocalTime.Month;
            int villagerMonth = _months[villagerMonthName.ToLower()];

            return currentMonth == villagerMonth;
        }

        public void RefreshLocalTime()
        {
            _localTime = Helper.GetUserCustomDateTime();
        }

        public bool UpdateLocalTime()
        {
            this.LocalTime = this.LocalTime.AddSeconds(1);
            return true;
        }
    }
}
