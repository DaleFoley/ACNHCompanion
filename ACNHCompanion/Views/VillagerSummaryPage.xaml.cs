using ACNHCompanion.ViewModels;
using System;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;

using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace ACNHCompanion.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class VillagerSummaryPage : ContentPage
    {
        private VillagerSummaryViewModel _villagersSummaryViewModel;
        private VillagersPage _villagerPage;

        public VillagerSummaryPage()
        {
            InitializeComponent();

            _villagersSummaryViewModel = new VillagerSummaryViewModel();
            BindingContext = _villagersSummaryViewModel;

            this.Appearing += VillagerSummaryPage_Appearing;
        }

        private void VillagerSummaryPage_Appearing(object sender, EventArgs e)
        {
            _villagersSummaryViewModel?.SetResidentCount();
        }

        private void AllVillagersTapGestureRecognizer_Tapped(object sender, EventArgs e)
        {
            VillagersViewModel villagerViewModel = new VillagersViewModel();

            _villagerPage = new VillagersPage();
            _villagerPage.Content = new VillagersContentView(villagerViewModel);

            Navigation.PushModalAsync(_villagerPage);
        }

        private void ResidentsTapGestureRecognizer_Tapped(object sender, EventArgs e)
        {
            string filter = "and IsResident <> 0";
            VillagersViewModel villagerViewModel = new VillagersViewModel(filter);

            _villagerPage = new VillagersPage();
            _villagerPage.Content = new VillagersContentView(villagerViewModel);

            Navigation.PushModalAsync(_villagerPage);
        }

        private void VillagerSpeciesTapGestureRecognizer_Tapped(object sender, EventArgs e)
        {
            Frame frame = (Frame)sender;
            Grid frameGrid = (Grid)frame.Children[0];
            Label speciesLabel = (Label)frameGrid.Children[1];

            string filter = "and Species = '" + speciesLabel.Text + "'";

            VillagersViewModel villagerViewModel = new VillagersViewModel(filter);

            _villagerPage = new VillagersPage();
            _villagerPage.Content = new VillagersContentView(villagerViewModel);

            Navigation.PushModalAsync(_villagerPage);
        }
    }
}
