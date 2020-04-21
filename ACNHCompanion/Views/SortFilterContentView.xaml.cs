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

        private void CloseButton_Clicked(object sender, EventArgs e)
        {

        }

        private void ApplyButton_Clicked(object sender, EventArgs e)
        {
            IsVisible = false;
            InputTransparent = true;

            _filterString = "";

            if (IsCatchable.IsToggled) { _filterString = "and IsCatchableBasedOnTime <> 0 and IsCatchableBasedOnMonth <> 0 "; }
            if (IsDonated.IsToggled) { _filterString += "and IsDonated <> 0 "; }

            //TODO: Can we utilize DB model here? What if column names change?
            _filterString += "order by ";

            bool isOrderByID = true;

            if (SortByName.SelectedItem.ToString().ToLower() != "none") { _filterString += "CritterName " + SortByName.SelectedItem + ", "; isOrderByID = false; }
            if (SortByPrice.SelectedItem.ToString().ToLower() != "none") { _filterString += "SellPrice " + SortByPrice.SelectedItem + ", "; isOrderByID = false; }
            if (SortByRarity.SelectedItem.ToString().ToLower() != "none") { _filterString += "Rarity " + SortByRarity.SelectedItem + ", "; isOrderByID = false; }
            if (SortByLocation.SelectedItem.ToString().ToLower() != "none") { _filterString += "Location " + SortByLocation.SelectedItem; isOrderByID = false; }
            _filterString = _filterString.TrimEnd(',', ' ');

            if (isOrderByID) { _filterString += " ID asc"; }

            //TODO: Don't think we have to keep assigning to fvm/bvm.
            if (CritterViewModel.GetType().Equals(typeof(FishViewModel)))
            {
                FishViewModel fvm = (FishViewModel)CritterViewModel;
                fvm.FilterString = _filterString;
                fvm.RefreshViewModel(_filterString);
            }
            else
            {
                BugsViewModel bvm = (BugsViewModel)CritterViewModel;
                bvm.FilterString = _filterString;
                bvm.RefreshViewModel(_filterString);
            }
        }
    }
}