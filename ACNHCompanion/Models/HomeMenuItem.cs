using System;
using System.Collections.Generic;
using System.Text;

namespace ACNHCompanion.Models
{
    public enum MenuItemType
    {
        Browse,
        About,
        Critters,
        Main
    }
    public class HomeMenuItem
    {
        public MenuItemType Id { get; set; }

        public string Title { get; set; }
    }
}
