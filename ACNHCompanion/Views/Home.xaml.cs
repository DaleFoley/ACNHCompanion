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
        public CrittersViewModel FishTab { get; set; }
        public BugsViewModel BugsTab { get; set; }

        public Home()
        {
            InitializeComponent();

            FishTab = new CrittersViewModel();
            BugsTab = new BugsViewModel();

            NavigationPage bugsPage = new NavigationPage(new CrittersPage());
            bugsPage.IconImageSource = "bug_Bell_cricket.png";
            bugsPage.Title = "Bugs";
            bugsPage.BindingContext = BugsTab;

            NavigationPage fishPage = new NavigationPage(new CrittersPage());
            fishPage.IconImageSource = "fish_anchovy.png";
            fishPage.Title = "Fish";
            fishPage.BindingContext = FishTab;

            Children.Add(bugsPage);
            Children.Add(fishPage);
        }
    }
}