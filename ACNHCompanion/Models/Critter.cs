using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Runtime.CompilerServices;
using System.Text;
using Xamarin.Forms;

namespace ACNHCompanion.Models
{
    public class Critter : INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler PropertyChanged;
        protected void OnNotifyPropertyChanged([CallerMemberName] string memberName = "")
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(memberName));
        }

        public int Id { get; set; }

        private bool _isDonated;
        public bool IsDonated
        {
            get
            {
                return _isDonated;
            }

            set
            {
                _isDonated = value;
                DonatedIcon = GetDonatedIcon();
            }
        }

        private bool _isSculpted;

        public bool IsSculpted
        {
            get { return _isSculpted; }
            set { _isSculpted = value; OnNotifyPropertyChanged(); }
        }


        //Change to auto property.
        private string _name;
        public string Name { get { return _name; } set { _name = value; OnNotifyPropertyChanged(); } }

        public string SellIcon { get; set; }
        public string ShadowSizeIcon { get; set; }
        public long SellPrice { get; set; }

        public string Location { get; set; }
        public string Icon { get; set; }
        public string Time { get; set; }

        public string _months;
        public string Months
        {
            get
            {
                return _months;
            }

            set
            {
                _months = value;
                OnNotifyPropertyChanged("Months");
            }
        }

        public string Rarity { get; set; }
        public string ShadowSize { get; set; }
        public string Type { get; set; }
        public string CatchStartTime { get; set; }
        public string CatchEndTime { get; set; }
        public double SellPricePenalty
        {
            get
            {
                int percentPenalty = 20; //Config, but I doubt AC will change this value.
                double penaltyToApply = (double)percentPenalty / 100 * SellPrice;

                return SellPrice - penaltyToApply;
            }
        }
        public long SellPriceBonus
        {
            get
            {
                double bonusToApply = 1.5;
                return (long)(SellPrice * bonusToApply);
            }
        }

        private string _donatedIcon;
        public string DonatedIcon
        {
            get
            {
                return GetDonatedIcon();
            }

            set
            {
                _donatedIcon = value;
                OnNotifyPropertyChanged();
            }
        }

        private string _sculptedIcon;

        public string SculptedIcon
        {
            get { return GetSculptedIcon(); }
            set { _sculptedIcon = value; OnNotifyPropertyChanged(); }
        }

        private string GetSculptedIcon()
        {
            if (IsSculpted)
            {
                return "sculpted.png";
            }
            else
            {
                return "sculpted_false.png";
            }
        }


        private string GetDonatedIcon()
        {
            if (IsDonated)
            {
                return "donated.png";
            }
            else
            {
                return "donated_false.png";
            }
        }
    }
}
