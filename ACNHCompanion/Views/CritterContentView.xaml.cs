using ACNHCompanion.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace ACNHCompanion.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class CritterContentView : ContentView
    {
        public CritterContentView()
        {
            InitializeComponent();
        }

        void OnSculptureTapped(object sender, EventArgs args)
        {
            TappedEventArgs e = (TappedEventArgs)args;

            Critter critterSelected = (Critter)e.Parameter;

            int critterID = critterSelected.Id;
            bool isSculpted = critterSelected.IsSculpted ? false : true;

            App.ApplicationDatabase.UpdateCritterIsSculpted(critterID, isSculpted);
            critterSelected.IsSculpted = isSculpted;
        }

        void OnDonatedTapped(object sender, EventArgs args)
        {
            TappedEventArgs e = (TappedEventArgs)args;

            Critter critterSelected = (Critter)e.Parameter;

            int critterID = critterSelected.Id;
            bool isDonated = critterSelected.IsDonated ? false : true;

            App.ApplicationDatabase.UpdateCritterIsDonated(critterID, isDonated);
            critterSelected.IsDonated = isDonated;
        }
    }
}