/*
 *
 *  Ortelius for Microservice Configuration Mapping
 *  Copyright (C) 2017 Catalyst Systems Corporation DBA OpenMake Software
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Affero General Public License as
 *  published by the Free Software Foundation, either version 3 of the
 *  License, or (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Affero General Public License for more details.
 *
 *  You should have received a copy of the GNU Affero General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

package dmadmin;

public class DMActionEditInfo implements java.io.Serializable {
	private static final long serialVersionUID = -5362995729983900561L;
	private int m_editid;
	private int m_userid;
	public DMActionEditInfo() {
		m_editid=0;
		m_userid=0;
    }
	public void setUserID(int id) {
		m_userid = id;
	}
	public void setEditID(int id) {
		m_editid = id;
	}
	
	public int getUserID() {
		return m_userid;
	}
	public int getEditID() {
		return m_editid;
	}
}
