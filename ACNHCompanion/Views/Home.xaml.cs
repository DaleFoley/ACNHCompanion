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
    public partial class Home : TabbedPage
    {
        public FishViewModel FishTab { get; set; }
        public BugsViewModel BugsTab { get; set; }
        public VillagersViewModel VillagersTab { get; set; }
        public DashboardViewModel DashboardTab { get; set; }

        public Home()
        {
            InitializeComponent();
        }

        public void SetupTabs()
        {
            DashboardPage dashboardPage = new DashboardPage();
            dashboardPage.BindingContext = DashboardTab;

            NavigationPage dashboardNavigationPage = new NavigationPage(dashboardPage);
            dashboardNavigationPage.Title = "Dashboard";
            dashboardNavigationPage.IconImageSource = "resident_icon";

            Children.Add(dashboardNavigationPage);

            this.CurrentPage = dashboardNavigationPage;

            FishTab = new FishViewModel();
            BugsTab = new BugsViewModel();
            VillagersTab = new VillagersViewModel();

            NavigationPage fishPage = new NavigationPage(new CrittersPage(FishTab));
            fishPage.IconImageSource = "fish_anchovy.png";
            fishPage.Title = "Fish";

            NavigationPage bugsPage = new NavigationPage(new CrittersPage(BugsTab));
            bugsPage.IconImageSource = "bug_Bell_cricket.png";
            bugsPage.Title = "Bugs";

            NavigationPage villagersPage = new NavigationPage(new VillagerSummaryPage());
            villagersPage.IconImageSource = "villagers.png";
            villagersPage.Title = "Villagers";

            Children.Add(fishPage);
            Children.Add(bugsPage);
            Children.Add(villagersPage);

            this.CurrentPageChanged += Home_CurrentPageChanged;
        }
        private void Home_CurrentPageChanged(object sender, EventArgs e)
        {
            NavigationPage navPage = (NavigationPage)this.CurrentPage;
            Page currentPage = navPage.CurrentPage;

            if (currentPage.GetType() == typeof(DashboardPage))
            {
                DashboardTab.UpdateUpcomingEvent();
                DashboardTab.UpdateVillagersWithBirthdays();
            }
        }
    }
}