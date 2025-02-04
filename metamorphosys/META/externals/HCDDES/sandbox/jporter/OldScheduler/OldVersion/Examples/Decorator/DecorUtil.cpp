// DecorUtil.cpp: implementation of the CDecorUtil class.
//
//////////////////////////////////////////////////////////////////////

//
// 12/06/2002 - modified by Ed Willink, Thales Research and Technology (abstract classes)
//

#include "stdafx.h"
#include "DecoratorStd.h"
#include "DecorUtil.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif


static bool fontBoldness[GME_FONT_KIND_NUM]		= { false, false, false, false };
static bool fontSemiboldness[GME_FONT_KIND_NUM]	= { true, true, false, true };
static int  fontSizes[GME_FONT_KIND_NUM]	= { 18, 15, 12, 15 };
static bool fontItalics[GME_FONT_KIND_NUM]	= { false, false, false, true };

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CDecorUtil::CDecorUtil()
{
	CreateFonts(normalFonts,FW_LIGHT);
	CreateFonts(semiboldFonts,FW_NORMAL);
	CreateFonts(boldFonts,FW_SEMIBOLD);
}


CDecorUtil::~CDecorUtil()
{
	DeletePens(pens);
	DeleteBrushes(brushes);

	POSITION pos = allFonts.GetHeadPosition();
	while(pos)
		delete allFonts.GetNext(pos);
}

void CDecorUtil::DeletePens(CPenTable &penTable)
{
	POSITION pos = penTable.GetStartPosition();
	CPen *pen;
	void *pt;
	while(pos) {
		penTable.GetNextAssoc(pos,pt,pen);
		delete pen;
	}
}

void CDecorUtil::DeleteBrushes(CBrushTable &brushTable)
{
	POSITION pos = brushTable.GetStartPosition();
	CBrush *brush;
	void *pt;
	while(pos) {
		brushTable.GetNextAssoc(pos,pt,brush);
		delete brush;
	}
}

void CDecorUtil::CreateFonts(CFont **font,int boldness)
{
	for (int i = 0; i < GME_FONT_KIND_NUM; i++) {
		font[i] = new CFont();
		font[i]->CreateFont(fontSizes[i],0,0,0,boldness,fontItalics[i],0,0,ANSI_CHARSET,
								  OUT_DEVICE_PRECIS,CLIP_DEFAULT_PRECIS,
								  PROOF_QUALITY,FF_SWISS,"Arial");
		allFonts.AddTail(font[i]);
	}	
}

int  CDecorUtil::GetFontSize(GMEFontKind kind)
{
	return fontBoldness[kind];
}

CFont *CDecorUtil::GetFont(GMEFontKind kind)
{
	return GetFont(kind, fontBoldness[kind],fontSemiboldness[kind]);
}

CFont *CDecorUtil::GetFont(int kindsize, bool bold, bool semibold)
{
	return bold ? boldFonts[kindsize] : (semibold ? semiboldFonts[kindsize] : normalFonts[kindsize]);
}

CPen *CDecorUtil::GetPen(COLORREF color,bool dash)
{
	CPen *pen = 0;
	if(!(pens.Lookup((void *)color,pen))) {
		pen = new CPen();
		pen->CreatePen((dash ? PS_DOT : PS_SOLID),1,color);
		pens.SetAt((void *)color,pen);
	}
	ASSERT(pen);
	return pen;
}

CBrush *CDecorUtil::GetBrush(COLORREF color)
{
	CBrush *brush = 0;
	if(!(brushes.Lookup((void *)color,brush))) {
		brush = new CBrush();
		brush->CreateSolidBrush(color);
		brushes.SetAt((void *)color,brush);
	}
	ASSERT(brush);
	return brush;
}

void CDecorUtil::Draw3DBox(CDC *pDC,CRect rect,int borderSize,COLORREF brColor,COLORREF modelColor,bool special)
{

	if(special)
		borderSize = borderSize * 2;
	else
		borderSize++;

	rect.DeflateRect(borderSize-2,borderSize-2);
	pDC->FillSolidRect(rect,modelColor);

	CPen *pen = GetPen(brColor);
	CPen *oldpen = pDC->SelectObject(pen);

	CRect brect = rect;
	CPen *hiPen = GetPen(GetLightBorderColor(modelColor));
	CPen *loPen = GetPen(GetDarkBorderColor(modelColor));
	for(int i = 0; i < borderSize; i++) {
		pDC->MoveTo(CPoint(brect.left,brect.bottom));
		pDC->SelectObject(hiPen);
		pDC->LineTo(brect.TopLeft());
		pDC->SelectObject(hiPen);
		pDC->LineTo(CPoint(brect.right,brect.top));
		pDC->SelectObject(loPen);
		pDC->LineTo(brect.BottomRight());
		pDC->SelectObject(loPen);
		pDC->LineTo(CPoint(brect.left,brect.bottom));
		brect.InflateRect(1,1);
	}

	pDC->SelectObject(pen);
	if(!special)
		rect.InflateRect(borderSize,borderSize);
	pDC->MoveTo(rect.TopLeft());
	pDC->LineTo(CPoint(rect.right,rect.top));
	pDC->LineTo(rect.BottomRight());
	pDC->LineTo(CPoint(rect.left,rect.bottom));
	pDC->LineTo(rect.TopLeft());
	if(!special)
		rect.DeflateRect(borderSize,borderSize);

	pDC->SelectObject(oldpen);
}

void CDecorUtil::Draw3DBox(CDC *pDC,CRect rect,COLORREF brColor,COLORREF color,bool isType)
{
	Draw3DBox(pDC,rect,GME_3D_BORDER_SIZE,brColor,color,isType);
}

void CDecorUtil::DrawFlatBox(CDC *pDC,CRect rect,COLORREF brColor,COLORREF color)
{
	Draw3DBox(pDC,rect,0,brColor,color);
}

COLORREF CDecorUtil::GetLightBorderColor(COLORREF color)
{
	int b = (color & 0xff0000) >> 16;
	int g = (color & 0xff00) >> 8;
	int r = (color & 0xff);
	r = min(0xff,r + 0x40);
	g = min(0xff,g + 0x40);
	b = min(0xff,b + 0x40);
	return RGB(r,g,b);
}

COLORREF CDecorUtil::GetDarkBorderColor(COLORREF color)
{
	int b = (color & 0xff0000) >> 16;
	int g = (color & 0xff00) >> 8;
	int r = (color & 0xff);
	r = max(0,r - 0x40);
	g = max(0,g - 0x40);
	b = max(0,b - 0x40);
	return RGB(r,g,b);
}

void CDecorUtil::DrawText(CDC *pDC,CString &txt,CPoint &pt,CFont *font,COLORREF color,int align)
{
	if(font == 0)
		return;
	pDC->SelectObject(font);
	pDC->SetTextAlign(align);
	SetBkMode(pDC->m_hDC,TRANSPARENT);
	pDC->SetTextColor(pDC->IsPrinting() ? GME_BLACK_COLOR : color);
	pDC->TextOut(pt.x,pt.y,(LPCTSTR)txt,txt.GetLength());
}

