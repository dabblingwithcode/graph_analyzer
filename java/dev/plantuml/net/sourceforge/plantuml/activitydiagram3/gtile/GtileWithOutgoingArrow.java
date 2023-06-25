/* ========================================================================
 * PlantUML : a free UML diagram generator
 * ========================================================================
 *
 * (C) Copyright 2009-2024, Arnaud Roques
 *
 * Project Info:  https://plantuml.com
 * 
 * If you like this project or if you find it useful, you can support us at:
 * 
 * https://plantuml.com/patreon (only 1$ per month!)
 * https://plantuml.com/paypal
 * 
 * This file is part of PlantUML.
 *
 * PlantUML is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * PlantUML distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
 * or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public
 * License for more details.
 *
 * You should have received a copy of the GNU General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
 * USA.
 *
 *
 * Original Author:  Arnaud Roques
 *
 *
 */
package net.sourceforge.plantuml.activitydiagram3.gtile;

import java.util.Collection;
import java.util.Collections;

import net.sourceforge.plantuml.klimt.UTranslate;
import net.sourceforge.plantuml.klimt.shape.TextBlockUtils;

public class GtileWithOutgoingArrow extends GtileWithMargin implements Gtile {

	public GtileWithOutgoingArrow(AbstractGtileRoot orig, double south) {
		super(orig, 0, south, 0);
		if (orig instanceof GtileEmpty) {
			System.err.println("Warning 1");
		}
	}

	@Override
	public Collection<GConnection> getInnerConnections() {
		final GConnection arrow = new GConnectionVerticalDown(UTranslate.dy(0), orig.getGPoint(GPoint.SOUTH_HOOK),
				UTranslate.dy(south), orig.getGPoint(GPoint.SOUTH_HOOK), TextBlockUtils.EMPTY_TEXT_BLOCK);
		return Collections.singletonList(arrow);
	}

}
