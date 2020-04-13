﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Runtime.CompilerServices;

using Xamarin.Forms;

using ACNHCompanion.Models;
using ACNHCompanion.Services;
using System.Windows.Input;
using System.Diagnostics;

namespace ACNHCompanion.ViewModels
{
    public class BaseViewModel : INotifyPropertyChanged
    {
        public List<Critter> Critters { get; set; }
        public ICommand tapCommand;

        public IDataStore<Item> DataStore => DependencyService.Get<IDataStore<Item>>();
        public IDataStore<Critter> CrittersDataStore => DependencyService.Get<IDataStore<Critter>>();

        bool isBusy = false;

        public ICommand TapCommand
        {
            get { return tapCommand; }
        }

        public void OnTapped(object s)
        {
            Debug.WriteLine("parameter: " + s);
        }

        public bool IsBusy
        {
            get { return isBusy; }
            set { SetProperty(ref isBusy, value); }
        }

        string title = string.Empty;
        public string Title
        {
            get { return title; }
            set { SetProperty(ref title, value); }
        }

        protected bool SetProperty<T>(ref T backingStore, T value,
            [CallerMemberName]string propertyName = "",
            Action onChanged = null)
        {
            if (EqualityComparer<T>.Default.Equals(backingStore, value))
                return false;

            backingStore = value;
            onChanged?.Invoke();
            OnPropertyChanged(propertyName);
            return true;
        }

        #region INotifyPropertyChanged
        public event PropertyChangedEventHandler PropertyChanged;
        protected void OnPropertyChanged([CallerMemberName] string propertyName = "")
        {
            var changed = PropertyChanged;
            if (changed == null)
                return;

            changed.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }
        #endregion
    }
}
