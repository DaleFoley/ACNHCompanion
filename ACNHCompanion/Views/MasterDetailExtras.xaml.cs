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
    public partial class MasterDetailExtras : MasterDetailPage
    {
        public MasterDetailExtras()
        {
            InitializeComponent();

            DashboardViewModel dashboardVM = new DashboardViewModel();

            MasterDetailExtrasMaster masterDetailExtrasMaster = new MasterDetailExtrasMaster();
            masterDetailExtrasMaster.DashboardVM = dashboardVM;

            this.Master = masterDetailExtrasMaster;

            Home homePage = new Home();
            homePage.DashboardTab = dashboardVM;
            homePage.SetupTabs();

            this.Detail = homePage;
        }
    }
}