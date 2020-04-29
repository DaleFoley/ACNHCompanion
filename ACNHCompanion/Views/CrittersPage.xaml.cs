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

//TODO: Fire search logic on text input
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

        private void Filter_Clicked(object sender, EventArgs e)
        {
            if (SearchFrame.IsVisible) { return;  }
            Helper.ToggleVisualElementVisibility(sortFilterContentView);
        }

        private void SearchBar_SearchButtonPressed(object sender, EventArgs e)
        {
            if(sortFilterContentView.IsVisible) { return; }
            Helper.ToggleVisualElementVisibility(SearchFrame);
        }

        private void SearchBar_Submitted(object sender, EventArgs e)
        {
            //DRY
            SearchBar searchBar = (SearchBar)sender;
            string searchCriteria = " and CritterName like '" + searchBar.Text +"%'";

            if (_critterView.GetType().Equals(typeof(FishViewModel)))
            {
                FishViewModel fishViewModel = (FishViewModel)_critterView;
                fishViewModel.FilterString = searchCriteria + fishViewModel.FilterString;
                fishViewModel.RefreshViewModel();
            }
            else
            {
                BugsViewModel bugsViewModel = (BugsViewModel)_critterView;
                bugsViewModel.FilterString = searchCriteria + bugsViewModel.FilterString;
                bugsViewModel.RefreshViewModel();
            }
        }

        private void SearchBar_PropertyChanged(object sender, System.ComponentModel.PropertyChangedEventArgs e)
        {
        }

        private void SearchBar_Unfocused(object sender, FocusEventArgs e)
        {
            Helper.ToggleVisualElementVisibility(SearchFrame);
        }
    }
}