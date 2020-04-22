using ACNHCompanion.Models;
using ACNHCompanion.ViewModels;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace ACNHCompanion.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class SearchResultsPage : ContentPage
    {
        public GlobalSearchViewModel globalSearchViewModel { get; set; }
        public SearchResultsPage(string searchCriteria)
        {
            InitializeComponent();

            globalSearchViewModel = new GlobalSearchViewModel(searchCriteria);
            BindingContext = globalSearchViewModel;
        }

        //DRY - CrittersPage
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
    }
}