using ACNHCompanion.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Diagnostics;
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
                if (value != _localTime)
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

        private Event _upcomingEvent;
        public Event UpcomingEvent
        {
            get { return _upcomingEvent; }
            set
            {
                if (value != _upcomingEvent)
                {
                    _upcomingEvent = value;
                    OnNotifyPropertyChanged(nameof(UpcomingEvent));
                }
            }
        }

        private string _eventDateDisplay;
        public string EventDateDisplay
        {
            get { return _eventDateDisplay; }
            set { if (value != _eventDateDisplay) { _eventDateDisplay = value; OnNotifyPropertyChanged(nameof(EventDateDisplay)); } }
        }


        public DashboardViewModel()
        {
            RefreshLocalTime();
            Device.StartTimer(TimeSpan.FromSeconds(1), () => UpdateLocalTime());

            UpdateUpcomingEvent();
            UpdateVillagersWithBirthdays();
        }

        public void UpdateVillagersWithBirthdays()
        {
            VillagersWithBirthdays = App.ApplicationDatabase.GetVillagerResidents();
            VillagersWithBirthdays = VillagersWithBirthdays.Where(villager => IsVillagerBirthdayThisMonth(villager.Birthday))
                .OrderBy(villager => villager.Birthday).ToList();
        }

        public void UpdateUpcomingEvent()
        {
            Config hemisphereConfig = App.Config.Where(c => c.Name == Strings.Config.HEMISPHERE).FirstOrDefault();
            string selectedHemisphere = hemisphereConfig.Value.ToLower();

            List<Event> gameEvents = App.ApplicationDatabase.GetEvents().Where(e => e.Hemisphere.ToLower() == "both" || e.Hemisphere.ToLower() == selectedHemisphere).ToList();
            foreach (Event gameEvent in gameEvents)
            {
                DateTime nextEventTime = new DateTime(LocalTime.Year, gameEvent.Month, gameEvent.Day);
                nextEventTime = GetNextEventTime(gameEvent.IsIntervalBased, nextEventTime);

                if (LocalTime < nextEventTime)
                {
                    UpcomingEvent = gameEvent;
                    EventDateDisplay = new DateTime(LocalTime.Year, nextEventTime.Month, nextEventTime.Day).ToString("MMMM dd");
                    break;
                }
            }
        }

        public DateTime GetNextEventTime(bool isIntervalBased, DateTime eventTime)
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

            return nextEventDateTime;
        }

        public DateTime GetEventDateTime(DateTime eventTime)
        {
            //TODO: unit test
            Calendar eventCalendar = CultureInfo.InvariantCulture.Calendar;

            int eventMonthTotalDays = eventCalendar.GetDaysInMonth(eventTime.Year, eventTime.Month);
            
            //In the database we actually store an integer to denote interval instead of an actual day number in the month
            //i.e 2 for second saturday of the month, 3 for third of the month etc..
            int eventInterval = eventTime.Day;
            int eventIntervalCount = 0;

            eventTime = new DateTime(eventTime.Year, eventTime.Month, 1);
            for (int idx = 0; idx < eventMonthTotalDays; idx++)
            {
                if(eventIntervalCount == eventInterval) { eventTime = eventTime.AddDays(-1); break; }

                DayOfWeek dow = eventTime.DayOfWeek;
                eventTime = eventTime.AddDays(1);

                if (dow == DayOfWeek.Saturday)
                {
                    eventIntervalCount++;
                    continue;
                }
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
