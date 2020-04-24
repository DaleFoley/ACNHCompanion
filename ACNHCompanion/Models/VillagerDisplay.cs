using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Runtime.CompilerServices;
using System.Text;

namespace ACNHCompanion.Models
{
    public class VillagerDisplay : INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler PropertyChanged;
        protected void OnNotifyPropertyChanged([CallerMemberName] string memberName = "")
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(memberName));
        }

        public string VillagerIcon { get; set; }
        public string VillagerImage { get; set; }
        public string VillagerName { get; set; }
        public string VillagerBirthday { get; set; }
        public string VillagerPersonality { get; set; }
        public string VillagerSpecies { get; set; }
        public string VillagerCatchPhrase { get; set; }
        public int IsResident
        {
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
                    OnNotifyPropertyChanged(IsResidentText);
                }
            }
        }

    }
}
