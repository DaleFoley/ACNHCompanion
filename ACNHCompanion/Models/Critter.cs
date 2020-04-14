using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Runtime.CompilerServices;
using System.Text;
using Xamarin.Forms;

namespace ACNHCompanion.Models
{
    //All of this could be done at the database level..
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

        private string _name;
        public string Name { get { return _name; } set { _name = value; OnNotifyPropertyChanged(); } }

        public string SellIcon { get; set; }
        public string ShadowSizeIcon { get; set; }
        public long SellPrice { get; set; }

        public string Location { get; set; }
        public string Icon { get; set; }
        public string Time { get; set; }
        public string Months { get; set; }
        public string Rarity { get; set; }
        public string ShadowSize { get; set; }
        public string Type { get; set; }
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
