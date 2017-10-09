using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Web;

namespace CleverNuts.Models
{
    public class EmailModel : IDataErrorInfo
    {
            private string _name;
            public string Name
            {
                get
                {
                    return _name;
                }
                set
                {
                    if (!string.IsNullOrEmpty(value))
                    {
                        _name = value;
                    }
                    else
                    {
                        _errors.Add("Name", "'Pseudo' is required.");
                    }
                }
            }


            private string _emailAddress;
            public string EmailAddress
            {
                get
                {
                    return _emailAddress;
                }
                set
                {
                    if (!string.IsNullOrEmpty(value))
                    {
                        _emailAddress = value;
                    }
                    else
                    {
                        _errors.Add("EmailAddress", "'Email' is required.");
                    }
                }
            }

            /* private string _phone;
            public string Phone
            {
                get
                {
                    return _phone;
                }
                set
                {
                    _phone = value;
                }
            }

            private string _webSite;
            public string WebSite
            {
                get
                {
                    return _webSite;
                }
                set
                {
                    _webSite = value;
                }
            }*/

            private string _subject;
            public string Subject
            {
                get
                {
                    return _subject;
                }
                set
                {
                    if (!string.IsNullOrEmpty(value))
                    {
                        _subject = value;
                    }
                    else
                    {
                        _errors.Add("Subject", "'Subject' is required.");
                    }
                }
            }


            private string _message;
            public string Message
            {
                get
                {
                    return _message;
                }
                set
                {
                    if (!string.IsNullOrEmpty(value))
                    {
                        _message = value;
                    }
                    else
                    {
                        _errors.Add("Message", "'Message' is required.");
                    }
                }
            }


            private Dictionary<string, string> _errors = new Dictionary<string, string>();

            #region IDataErrorInfo Members

            public string Error
            {
                get
                {
                    return null;
                }
            }

            public string this[string columnName]
            {
                get
                {
                    string error;
                    if (_errors.TryGetValue(columnName, out error))
                    {
                        return error;
                    }
                    else
                    {
                        return null;
                    }
                }
            }

            #endregion
        }
    }