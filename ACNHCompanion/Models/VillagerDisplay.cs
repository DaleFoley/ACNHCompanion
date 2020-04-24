using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Runtime.CompilerServices;
using System.Text;
using System.Windows.Input;
using Xamarin.Forms;

namespace ACNHCompanion.Models
{
    public class VillagerDisplay : INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler PropertyChanged;
        protected void OnNotifyPropertyChanged([CallerMemberName] string memberName = "")
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(memberName));
        }

        public int ID { get; set; }
        public string VillagerIcon { get; set; }
        public string VillagerImage { get; set; }
        public string VillagerName { get; set; }
        public string VillagerBirthday { get; set; }
        public string VillagerPersonality { get; set; }
        public string VillagerSpecies { get; set; }
        public string VillagerCatchPhrase { get; set; }

        private int _isResident;
        public int IsResident
        {
            get
            {
                return _isResident;
            }
            set
            {
                if(value != 0)
                {
                    IsResidentText = "Resident";
                }
                else
                {
                    IsResidentText = "Not A Resident";
                }

                _isResident = value;
            }
        }

        private string _isResidentText;
        public string IsResidentText
        {
            get
            {
                return _isResidentText;
            }
            set
            {
                if(value != _isResidentText)
                {
                    _isResidentText = value;
                    OnNotifyPropertyChanged(nameof(IsResidentText));
                }
            }
        }

    }
}
