using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Runtime.CompilerServices;
using System.Text;
using Xamarin.Forms;

namespace ACNHCompanion.Models
{
    public class Critter : ObservableObject
    {
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
            set { if (value != _isSculpted) { _isSculpted = value; SculptedIcon = GetSculptedIcon(); } }
        }


        //Change to auto property.
        private string _name;
        public string Name { get { return _name; } set { _name = value; OnNotifyPropertyChanged(nameof(Name)); } }

        public string SellIcon { get; set; }
        public string ShadowSizeIcon { get; set; }
        public long SellPrice { get; set; }

        public string Location { get; set; }
        public string Icon { get; set; }
        public string Time { get; set; }

        public string _months;
        public string Months
        {
            get { return _months; }
            set { if (value != _months) { _months = value; OnNotifyPropertyChanged(nameof(Months)); } }
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
            get { return GetDonatedIcon(); }
            set { if (value != _donatedIcon) { _donatedIcon = value; OnNotifyPropertyChanged(nameof(DonatedIcon)); } }
        }

        private string _sculptedIcon;

        public string SculptedIcon
        {
            get { return GetSculptedIcon(); }
            set { if (value != _sculptedIcon) { _sculptedIcon = value; OnNotifyPropertyChanged(nameof(SculptedIcon)); } }
        }

        private string GetSculptedIcon()
        {
            if (IsSculpted)
            {
                return "sculpture.png";
            }
            else
            {
                return "sculpture_false.png";
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
