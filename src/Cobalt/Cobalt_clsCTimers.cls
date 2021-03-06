VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsCTimers"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'*******************************************************************'
'                           OpenARC                                 '
'                     Cobalt Gaming Systems                         '
' This program is free software; you can redistribute it and/or     '
' modify it under the terms of the GNU General Public License       '
' as published by the Free Software Foundation; either version 2    '
' of the License, or (at your option) any later version.            '
'                                                                   '
' This program is distributed in the hope that it will be useful,   '
' but WITHOUT ANY WARRANTY; without even the implied warranty of    '
' MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the      '
' GNU General Public License for more details.                      '
'                                                                   '
' You should have received a copy of the GNU General Public License '
' along with this program; if not, write to the Free Software       '
' Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.         '
'                                                                   '
'             This module was created by David Zimmer               '
'*******************************************************************'

Option Explicit
Public Event Timer(ByVal Index As Integer)
Private mCount As Integer
Private mCol As New Collection 'object ref to child clsCTimer classes created by this class
Private mClassKey As Integer

Property Get Count() As Integer
    Count = mCount
End Property

Function Add() As Integer
    Dim t As New clsCTimer
    
    mCount = mCount + 1 '1 based indexes (same as collection object)
    
    'these two friend properties were added to base class (CTimer) to support this framework
    t.Index = mCount
    t.ParentsColKey = mClassKey
    
    mCol.Add t
    Add = mCount
    
End Function

Function BulkLoad(num As Integer)
    Dim I As Long
    
    'mabey add check to make sure .Add() not called before, so indexes are auto aligned 1-num ?
    If num > 0 And num < 200 Then
        For I = 0 To num
            Add
        Next
    Else
        Err.Raise vbObjectError, "clsCTimers.BulkLoad", "No more than 200 times allowed per class"
    End If
                    
End Function


'default function of class (so we can refer to it as myCTimersClass(index).
Function Item(ByVal Index As Integer) As clsCTimer
Attribute Item.VB_UserMemId = 0
    If Index > Count Then Err.Raise vbObjectError, "clsCTimers.Item", "Index does not Exist"
    Set Item = mCol(Index)
End Function

'called from modTimer directly
Friend Function RaiseTimer_Event(ByVal Index As Integer)
    RaiseEvent Timer(Index)
End Function

Private Sub Class_Initialize()
    mClassKey = RegisterTimerCollection(Me)
End Sub

Private Sub Class_Terminate()
    Dim t As clsCTimer
    
    For Each t In mCol
        Set t = Nothing
    Next
    
    Set mCol = Nothing
    
    clsCTimersCol.Remove "key:" & mClassKey
    
End Sub
