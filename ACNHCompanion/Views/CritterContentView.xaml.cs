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
            Helper.UpdateCritterIsSculpted((TappedEventArgs)args);
        }

        void OnDonatedTapped(object sender, EventArgs args)
        {
            Helper.UpdateCritterIsDonated((TappedEventArgs)args);
        }

        void OnCapturedTapped(object sender, EventArgs args)
        {
            Helper.UpdateCritterIsCaptured((TappedEventArgs)args);
        }
    }
}