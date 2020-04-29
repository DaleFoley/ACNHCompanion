using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;

using ACNHCompanion.Models;
using ACNHCompanion.Views;
using ACNHCompanion.ViewModels;
using System.Diagnostics;

namespace ACNHCompanion.Views
{
    // Learn more about making custom code visible in the Xamarin.Forms previewer
    // by visiting https://aka.ms/xamarinforms-previewer
    [DesignTimeVisible(false)]
    public partial class DashboardPage : ContentPage
    {
        public DashboardPage()
        {
            InitializeComponent();
        }

        private void SearchBarGlobal_SearchButtonPressed(object sender, EventArgs e)
        {
            SearchFrame.IsVisible = SearchFrame.IsVisible ? false : true;
            SearchFrame.InputTransparent = SearchFrame.InputTransparent ? true : false;
        }

        async private void SearchBar_SearchButtonPressed(object sender, EventArgs e)
        {
            SearchBar searchBar = (SearchBar)sender;
            string searchCriteria = searchBar.Text;

            await Navigation.PushModalAsync(new SearchResultsPage(searchCriteria));
        }
    }
}