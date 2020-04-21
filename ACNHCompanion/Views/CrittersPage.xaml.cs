using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using Xamarin.Forms;
using Xamarin.Forms.Xaml;

using ACNHCompanion.Models;
using ACNHCompanion.Views;
using ACNHCompanion.ViewModels;
using System.Diagnostics;

namespace ACNHCompanion.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class CrittersPage : ContentPage
    {
        public BaseViewModel _critterView { get; set; }
        public CrittersPage(BaseViewModel critterView)
        {
            _critterView = critterView;
            BindingContext = critterView;

            InitializeComponent();

            sortFilterContentView.CritterViewModel = _critterView;
        }

        void OnDonatedTapped(object sender, EventArgs args)
        {
            try
            {
                TappedEventArgs e = (TappedEventArgs)args;

                Critter critterSelected = (Critter)e.Parameter;

                int critterID = critterSelected.Id;
                bool isDonated = critterSelected.IsDonated ? false : true;

                App.ApplicationDatabase.UpdateCritterIsDonated(critterID, isDonated);
                critterSelected.IsDonated = isDonated;
            }
            catch (Exception)
            {
                //TODO: Logging exceptions..
                Debugger.Break();
                throw;
            }
        }

        private void ToolbarItem_Clicked(object sender, EventArgs e)
        {
            sortFilterContentView.IsVisible = true;
            sortFilterContentView.InputTransparent = false;
        }
    }
}