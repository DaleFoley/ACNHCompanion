using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Diagnostics;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;

using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace ACNHCompanion.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class MasterDetailExtrasMaster : ContentPage
    {

        public MasterDetailExtrasMaster()
        {
            InitializeComponent();
        }

        void TapGestureRecognizer_Tapped(object sender, EventArgs args)
        {
            Image i = (Image)sender;
            i.Source = "north_hemi_selected.png";

            DisplayAlert("test", "test", "test");
            Debugger.Break();
        }
    }
}