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
    public partial class Home : TabbedPage
    {
        public FishViewModel FishTab { get; set; }
        public BugsViewModel BugsTab { get; set; }
        public VillagersViewModel VillagersTab { get; set; }

        public Home()
        {
            InitializeComponent();

            FishTab = new FishViewModel();
            BugsTab = new BugsViewModel();
            VillagersTab = new VillagersViewModel();

            NavigationPage fishPage = new NavigationPage(new CrittersPage(FishTab));
            fishPage.IconImageSource = "fish_anchovy.png";
            fishPage.Title = "Fish";

            NavigationPage bugsPage = new NavigationPage(new CrittersPage(BugsTab));
            bugsPage.IconImageSource = "bug_Bell_cricket.png";
            bugsPage.Title = "Bugs";

            NavigationPage villagersPage = new NavigationPage(new VillagersPage(VillagersTab));
            villagersPage.IconImageSource = "villagers_icon.png";
            villagersPage.Title = "Villagers";

            Children.Add(fishPage);
            Children.Add(bugsPage);
            Children.Add(villagersPage);
        }
    }
}