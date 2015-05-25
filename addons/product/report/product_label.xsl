<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
    xmlns:date="http://exslt.org/dates-and-times" 
    extension-element-prefixes="date"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:fo="http://www.w3.org/1999/XSL/Format">

    <xsl:import href="date/date.date.xsl" />

	<xsl:variable name="initial_bottom_pos">23.5</xsl:variable>
	<xsl:variable name="initial_left_pos">0.5</xsl:variable>
	<xsl:variable name="height_increment">4.4</xsl:variable> <!-- смещение ценника для следующего по горизонтали(вниз) -->
	<xsl:variable name="width_increment">4.5</xsl:variable> <!-- смещение ценника для следующего по вертикали(вправо) -->
	<xsl:variable name="frame_height">5cm</xsl:variable> <!-- высота ценника, общее выделяемое пространство -->
	<xsl:variable name="frame_width">5cm</xsl:variable> <!-- ширина ценника, общее выделяемое пространство -->
	<xsl:variable name="number_columns">4</xsl:variable> <!-- количество ценников по горизонтали(колонок) на странице/листе -->
	<xsl:variable name="max_frames">28</xsl:variable> <!-- максимальное количество ценников на странице/листе (расчет = 7строк * number_columns) -->

	<xsl:template match="/">
		<xsl:apply-templates select="lots"/>
	</xsl:template>

	<xsl:template match="lots">
		<document>
			<template leftMargin="2.0cm" rightMargin="2.0cm" topMargin="2.0cm" bottomMargin="2.0cm" title="Address list" author="Generated by Ant">
				<pageTemplate id="all">
					<pageGraphics/>
					<xsl:apply-templates select="lot-line" mode="frames"/>
				</pageTemplate>
			</template>
			<stylesheet>
				<paraStyle name="nospace" fontName="Courier" fontSize="12" spaceBefore="0" spaceAfter="0" alignment="CENTER"/> <!-- шрифт по умолчанию -->
				<blockTableStyle id="mytable">
					<blockBackground colorName="lightgrey" start="0,0" stop="0,0"/> <!-- раскраска ячейки цветом -->
					<blockBackground colorName="lightred" start="1,0" stop="-1,0"/>
					<blockAlignment value="CENTER"/>
					<blockValign value="MIDDLE"/>
					<blockFont name="Helvetica-BoldOblique" size="14" start="0,0" stop="-1,0"/>
					<blockFont name="Helvetica" size="12" start="0,1" stop="-1,1"/>
					<lineStyle kind="GRID" colorName="black" tickness="1"/> <!-- стиль таблицы(обрамление) -->
				</blockTableStyle>
			</stylesheet>
			<story>
				<xsl:apply-templates select="lot-line" mode="story"/>
			</story>
		</document>
	</xsl:template>

	<xsl:template match="lot-line" mode="frames">
		<xsl:if test="position() &lt; $max_frames + 1">
			<frame>
				<xsl:attribute name="width">
					<xsl:value-of select="$frame_width"/>
				</xsl:attribute>
				<xsl:attribute name="height">
					<xsl:value-of select="$frame_height"/>
				</xsl:attribute>
				<xsl:attribute name="x1">
					<xsl:value-of select="$initial_left_pos + ((position()-1) mod $number_columns) * $width_increment"/>
					<xsl:text>cm</xsl:text>
				</xsl:attribute>
				<xsl:attribute name="y1">
					<xsl:value-of select="$initial_bottom_pos - floor((position()-1) div $number_columns) * $height_increment"/>
					<xsl:text>cm</xsl:text>
				</xsl:attribute>
			</frame>
		</xsl:if>
	</xsl:template>

	<xsl:param name="pmaxChars" as="xs:integer" select="80"/> <!-- переменная устанавливаетс максимальное количество симполов в строке вывода -->

	<xsl:template match="lot-line" mode="story">
            <blockTable style="mytable" colWidths="4.4cm">
                <tr>
                    <td>
                        <para alignment="CENTER"><xsl:value-of select="company"/></para>
                    </td>
                </tr>
                <tr>
                    <td>
                        <para fontSize="12"  alignment="CENTER"><b><xsl:value-of select="substring(product, 1, $pmaxChars)"/><!--обрезает строку с названием до 80 символов --></b></para><xsl:text>, </xsl:text>
                        <!--<para style="nospace"><xsl:value-of select="variant"/></para>-->

                        <!--<para fontSize="10">
			    <xsl:text>Цена за </xsl:text><xsl:value-of select="uom"/>
			    <xsl:text> </xsl:text><b><xsl:value-of select="price"/></b><xsl:text>  </xsl:text><xsl:value-of select="currency"/>
			</para>-->
                        <para fontSize="10" alignment="CENTER">
			    <xsl:value-of select="uom"/>
			</para>
                        <para fontSize="16" alignment="CENTER">
			    <b><xsl:value-of select="price"/></b>
			</para>

			<spacer length="0.5cm"/>

                        <barCode><xsl:value-of select="ean13" /></barCode> 
                        <!--<para fontSize="6" style="nospace"><xsl:value-of select="ean13"/></para>-->
                        <!--<para style="nospace"><xsl:value-of select="code"/></para>-->
                    </td>
                </tr>
                <tr>
                    <td>
                        <para fontSize="5" style="nospace">
			    <xsl:text>Дата: </xsl:text><!--<xsl:value-of select="date:date()"/>-->
			    <xsl:value-of select="date:day-in-month()"/>.<xsl:value-of select="date:month-in-year()"/>.<xsl:value-of select="date:year()"/>
			    <xsl:text> </xsl:text><xsl:value-of select="company_registry"/>
			</para>
                    </td>
                </tr>
            </blockTable>
	<nextFrame/>
	</xsl:template>
</xsl:stylesheet>
