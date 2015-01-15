﻿/*
Copyright (C) 2013-2015 MetaMorph Software, Inc

Permission is hereby granted, free of charge, to any person obtaining a
copy of this data, including any software or models in source or binary
form, as well as any drawings, specifications, and documentation
(collectively "the Data"), to deal in the Data without restriction,
including without limitation the rights to use, copy, modify, merge,
publish, distribute, sublicense, and/or sell copies of the Data, and to
permit persons to whom the Data is furnished to do so, subject to the
following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Data.

THE DATA IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
THE AUTHORS, SPONSORS, DEVELOPERS, CONTRIBUTORS, OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE DATA OR THE USE OR OTHER DEALINGS IN THE DATA.  

=======================
This version of the META tools is a fork of an original version produced
by Vanderbilt University's Institute for Software Integrated Systems (ISIS).
Their license statement:

Copyright (C) 2011-2014 Vanderbilt University

Developed with the sponsorship of the Defense Advanced Research Projects
Agency (DARPA) and delivered to the U.S. Government with Unlimited Rights
as defined in DFARS 252.227-7013.

Permission is hereby granted, free of charge, to any person obtaining a
copy of this data, including any software or models in source or binary
form, as well as any drawings, specifications, and documentation
(collectively "the Data"), to deal in the Data without restriction,
including without limitation the rights to use, copy, modify, merge,
publish, distribute, sublicense, and/or sell copies of the Data, and to
permit persons to whom the Data is furnished to do so, subject to the
following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Data.

THE DATA IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
THE AUTHORS, SPONSORS, DEVELOPERS, CONTRIBUTORS, OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE DATA OR THE USE OR OTHER DEALINGS IN THE DATA.  
*/

namespace CyPhyMasterInterpreter
{
    partial class ProgressDialog
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(ProgressDialog));
            this.lblMultiple = new System.Windows.Forms.Label();
            this.lblSingle = new System.Windows.Forms.Label();
            this.progressBarMultiple = new System.Windows.Forms.ProgressBar();
            this.progressBarSingle = new System.Windows.Forms.ProgressBar();
            this.lblTimeEstimate = new System.Windows.Forms.Label();
            this.SuspendLayout();
            // 
            // lblMultiple
            // 
            this.lblMultiple.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.lblMultiple.AutoEllipsis = true;
            this.lblMultiple.Location = new System.Drawing.Point(12, 9);
            this.lblMultiple.Name = "lblMultiple";
            this.lblMultiple.Size = new System.Drawing.Size(660, 20);
            this.lblMultiple.TabIndex = 0;
            this.lblMultiple.Text = "Multiple progess text";
            // 
            // lblSingle
            // 
            this.lblSingle.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.lblSingle.AutoEllipsis = true;
            this.lblSingle.Location = new System.Drawing.Point(12, 59);
            this.lblSingle.Name = "lblSingle";
            this.lblSingle.Size = new System.Drawing.Size(660, 20);
            this.lblSingle.TabIndex = 2;
            this.lblSingle.Text = "Single progess text";
            // 
            // progressBarMultiple
            // 
            this.progressBarMultiple.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.progressBarMultiple.Location = new System.Drawing.Point(12, 24);
            this.progressBarMultiple.Name = "progressBarMultiple";
            this.progressBarMultiple.Size = new System.Drawing.Size(660, 25);
            this.progressBarMultiple.TabIndex = 1;
            // 
            // progressBarSingle
            // 
            this.progressBarSingle.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.progressBarSingle.Location = new System.Drawing.Point(12, 74);
            this.progressBarSingle.Name = "progressBarSingle";
            this.progressBarSingle.Size = new System.Drawing.Size(660, 25);
            this.progressBarSingle.TabIndex = 3;
            // 
            // lblTimeEstimate
            // 
            this.lblTimeEstimate.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.lblTimeEstimate.Location = new System.Drawing.Point(12, 104);
            this.lblTimeEstimate.Name = "lblTimeEstimate";
            this.lblTimeEstimate.RightToLeft = System.Windows.Forms.RightToLeft.No;
            this.lblTimeEstimate.Size = new System.Drawing.Size(660, 20);
            this.lblTimeEstimate.TabIndex = 10;
            this.lblTimeEstimate.Text = "00:00";
            this.lblTimeEstimate.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // ProgressDialog
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(96F, 96F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Dpi;
            this.ClientSize = new System.Drawing.Size(684, 132);
            this.Controls.Add(this.lblTimeEstimate);
            this.Controls.Add(this.progressBarSingle);
            this.Controls.Add(this.progressBarMultiple);
            this.Controls.Add(this.lblSingle);
            this.Controls.Add(this.lblMultiple);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "ProgressDialog";
            this.SizeGripStyle = System.Windows.Forms.SizeGripStyle.Hide;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Master Interpreter Progress Status";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.ProgressDialog_FormClosing);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Label lblMultiple;
        private System.Windows.Forms.Label lblSingle;
        private System.Windows.Forms.ProgressBar progressBarMultiple;
        private System.Windows.Forms.ProgressBar progressBarSingle;
        private System.Windows.Forms.Label lblTimeEstimate;
    }
}