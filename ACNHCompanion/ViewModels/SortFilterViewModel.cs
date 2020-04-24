using System;
using System.Collections.Generic;
using System.Text;

namespace ACNHCompanion.ViewModels
{
    public class SortFilterViewModel
    {
        public string[] SortCriteria { get; set; }
        public string[] FilterCriteria { get; set; }
        public int DefaultSelectedSortIndex { get; set; }
        public int DefaultSelectedFilterIndex { get; set; }

        public SortFilterViewModel()
        {
            SortCriteria = new string[3];
            SortCriteria[0] = "Asc";
            SortCriteria[1] = "Desc";
            SortCriteria[2] = "None";

            DefaultSelectedSortIndex = 2;

            FilterCriteria = new string[3];
            FilterCriteria[0] = "Yes";
            FilterCriteria[1] = "No";
            FilterCriteria[2] = "None";

            DefaultSelectedFilterIndex = 2;
        }
    }
}
