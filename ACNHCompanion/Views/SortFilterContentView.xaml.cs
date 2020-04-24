using ACNHCompanion.Models;
using ACNHCompanion.ViewModels;
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
    public partial class SortFilterContentView : ContentView
    {
        private SortFilterViewModel _sortFilterViewModel;
        private string _filterString;

        public BaseViewModel CritterViewModel { get; set; }

        public SortFilterContentView()
        {
            InitializeComponent();

            _sortFilterViewModel = new SortFilterViewModel();
            BindingContext = _sortFilterViewModel;
        }

        private void RefreshCritterPage(BaseViewModel baseViewModel, string filterString = "")
        {
            if (baseViewModel.GetType().Equals(typeof(FishViewModel)))
            {
                FishViewModel fishViewModel = (FishViewModel)baseViewModel;
                fishViewModel.FilterString = filterString;
                fishViewModel.RefreshViewModel();
            }
            else
            {
                BugsViewModel bugsViewModel = (BugsViewModel)baseViewModel;
                bugsViewModel.FilterString = filterString;
                bugsViewModel.RefreshViewModel();
            }
        }

        private void CloseButton_Clicked(object sender, EventArgs e)
        {
            IsVisible = false;
            InputTransparent = true;
        }

        private void ClearButton_Clicked(object sender, EventArgs e)
        {
            IsVisible = false;
            InputTransparent = true;

            //Should really reference _sortFilterViewModel.Default*Index but the value was changing during runtime, not sure how that was happening...
            FilterByDonated.SelectedItem = _sortFilterViewModel.FilterCriteria[2];
            FilterByCatchable.SelectedItem = _sortFilterViewModel.FilterCriteria[2];

            SortByLocation.SelectedItem = _sortFilterViewModel.SortCriteria[2];
            SortByName.SelectedItem = _sortFilterViewModel.SortCriteria[2];
            SortByPrice.SelectedItem = _sortFilterViewModel.SortCriteria[2];
            SortByRarity.SelectedItem = _sortFilterViewModel.SortCriteria[2];

            RefreshCritterPage(CritterViewModel);
        }

        private void ApplyButton_Clicked(object sender, EventArgs e)
        {
            IsVisible = false;
            InputTransparent = true;

            _filterString = "";

            if(FilterByDonated.SelectedItem.ToString().ToLower() == "yes")
            {
                _filterString += "and IsDonated <> 0 ";
            }
            else if(FilterByDonated.SelectedItem.ToString().ToLower() == "no")
            {
                _filterString += "and IsDonated == 0 ";
            }

            if (FilterByCatchable.SelectedItem.ToString().ToLower() == "yes")
            {
                _filterString += "and IsCatchableBasedOnTime <> 0 and IsCatchableBasedOnMonth <> 0 ";
            }
            else if (FilterByCatchable.SelectedItem.ToString().ToLower() == "no")
            {
                _filterString += "and IsCatchableBasedOnTime == 0 and IsCatchableBasedOnMonth == 0 ";
            }

            //TODO: Can we utilize DB model here? What if column names change?
            _filterString += "order by ";

            bool isOrderByID = true;

            if (SortByName.SelectedItem.ToString().ToLower() != "none") { _filterString += "CritterName " + SortByName.SelectedItem + ", "; isOrderByID = false; }
            if (SortByPrice.SelectedItem.ToString().ToLower() != "none") { _filterString += "SellPrice " + SortByPrice.SelectedItem + ", "; isOrderByID = false; }
            if (SortByRarity.SelectedItem.ToString().ToLower() != "none") { _filterString += "Rarity " + SortByRarity.SelectedItem + ", "; isOrderByID = false; }
            if (SortByLocation.SelectedItem.ToString().ToLower() != "none") { _filterString += "Location " + SortByLocation.SelectedItem; isOrderByID = false; }
            _filterString = _filterString.TrimEnd(',', ' ');

            if (isOrderByID) { _filterString += " ID asc"; }

            RefreshCritterPage(CritterViewModel, _filterString);
        }
    }
}