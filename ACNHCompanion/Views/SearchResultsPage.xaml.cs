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
            Helper.UpdateCritterIsDonated((TappedEventArgs)args);
        }

        private void ToggleHideShowBugs_Clicked(object sender, EventArgs e)
        {
            ToggleStackLayoutDisplay(collectionBugs, (Button)sender);
        }

        private void ToggleHideShowFish_Clicked(object sender, EventArgs e)
        {
            ToggleStackLayoutDisplay(collectionFish, (Button)sender);
        }

        private void ToggleStackLayoutDisplay(StackLayout collection, Button button)
        {
            Grid grid = (Grid)collection.Parent;
            object rowID = collection.GetValue(Grid.RowProperty);

            GridLength gridLengthShown = new GridLength(1, GridUnitType.Star);
            GridLength gridLengthHidden = new GridLength(0, GridUnitType.Absolute);

            if (collection.IsVisible)
            {
                collection.IsVisible = false;
                grid.RowDefinitions[(int)rowID].Height = gridLengthHidden;

                button.Text = "Show";
            }
            else
            {
                collection.IsVisible = true;
                grid.RowDefinitions[(int)rowID].Height = gridLengthShown;

                button.Text = "Hide";
            }
        }
    }
}