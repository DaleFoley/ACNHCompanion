﻿using System;
using System.Collections.Generic;
using System.Text;

namespace ACNHCompanion.ViewModels
{
    public class SortFilterViewModel
    {
        public string[] SortCriteria { get; set; }
        public int DefaultSelectedIndex { get; set; }

        public SortFilterViewModel()
        {
            SortCriteria = new string[3];
            SortCriteria[0] = "Asc";
            SortCriteria[1] = "Desc";
            SortCriteria[2] = "None";

            DefaultSelectedIndex = 2;
        }
    }
}