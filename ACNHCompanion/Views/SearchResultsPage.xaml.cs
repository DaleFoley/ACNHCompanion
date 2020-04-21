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
    public partial class SearchResultsPage : ContentPage
    {
        public GlobalSearchViewModel globalSearchViewModel { get; set; }
        public SearchResultsPage(string searchCriteria)
        {
            InitializeComponent();

            globalSearchViewModel = new GlobalSearchViewModel(searchCriteria);
            BindingContext = globalSearchViewModel;
        }

    }
}