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
        public GlobalSearchViewModel GlobalSearchViewModel { get; set; }
        public SearchResultsPage(string searchCriteria)
        {
            InitializeComponent();

            GlobalSearchViewModel = new GlobalSearchViewModel(searchCriteria);
            BindingContext = GlobalSearchViewModel;

            ContentView bugsContentView = critterBugs;
            bugsContentView.Content.SetBinding(ItemsView.ItemsSourceProperty, "BugsDisplay");

            ContentView fishContentView = critterFish;
            fishContentView.Content.SetBinding(ItemsView.ItemsSourceProperty, "FishDisplay");

            string villagerFilter = "and Name like '" + searchCriteria + "%'";
            VillagersViewModel villagerViewModel = new VillagersViewModel(villagerFilter);
            ContentView villagerContentView = new VillagersContentView(villagerViewModel);            

            collectionVillagers.Children.Add(villagerContentView);
        }

        private void ToggleHideShowBugs_Clicked(object sender, EventArgs e)
        {
            ToggleStackLayoutDisplay(collectionBugs, (Button)sender);
        }

        private void ToggleHideShowFish_Clicked(object sender, EventArgs e)
        {
            ToggleStackLayoutDisplay(collectionFish, (Button)sender);
        }
        private void ToggleHideShowVillagers_Clicked(object sender, EventArgs e)
        {
            ToggleStackLayoutDisplay(collectionVillagers, (Button)sender);
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